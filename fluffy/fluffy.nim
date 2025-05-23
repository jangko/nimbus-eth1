# Fluffy
# Copyright (c) 2021-2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.push raises: [].}

import
  std/[os, enumutils, exitprocs],
  confutils,
  confutils/std/net,
  chronicles,
  chronicles/topics_registry,
  chronos,
  metrics,
  metrics/chronos_httpserver,
  json_rpc/clients/httpclient,
  results,
  stew/[byteutils, io2],
  eth/common/keys,
  eth/net/nat,
  eth/p2p/discoveryv5/protocol as discv5_protocol,
  ./conf,
  ./network_metadata,
  ./common/common_utils,
  ./evm/[async_evm, async_evm_portal_backend],
  ./rpc/[
    rpc_eth_api, rpc_debug_api, rpc_discovery_api, rpc_portal_common_api,
    rpc_portal_history_api, rpc_portal_beacon_api, rpc_portal_state_api,
    rpc_portal_nimbus_beacon_api, rpc_portal_debug_history_api,
  ],
  ./database/content_db,
  ./network/wire/portal_protocol_version,
  ./portal_node,
  ./version,
  ./logging

chronicles.formatIt(IoErrorCode):
  $it

func optionToOpt[T](o: Option[T]): Opt[T] =
  if o.isSome():
    Opt.some(o.unsafeGet())
  else:
    Opt.none(T)

type
  FluffyStatus = enum
    Starting
    Running
    Stopping

  Fluffy = ref object
    status: FluffyStatus
    portalNode: PortalNode
    metricsServer: Opt[MetricsHttpServerRef]
    rpcHttpServer: Opt[RpcHttpServer]
    rpcWsServer: Opt[RpcWebSocketServer]

proc init(T: type Fluffy): T =
  Fluffy(status: FluffyStatus.Starting)

proc run(fluffy: Fluffy, config: PortalConf) {.raises: [CatchableError].} =
  setupLogging(config.logLevel, config.logStdout, none(OutFile))

  notice "Launching Fluffy", version = fullVersionStr, cmdParams = commandLineParams()

  let rng = newRng()

  # Make sure dataDir exists
  let pathExists = createPath(config.dataDir.string)
  if pathExists.isErr():
    fatal "Failed to create data directory",
      dataDir = config.dataDir, error = pathExists.error
    quit QuitFailure

  # Make sure multiple instances to the same dataDir do not exist
  let
    lockFilePath = config.dataDir.string / "fluffy.lock"
    lockFlags = {OpenFlags.Create, OpenFlags.Read, OpenFlags.Write}
    lockFileHandleResult = openFile(lockFilePath, lockFlags)

  if lockFileHandleResult.isErr():
    fatal "Failed to open lock file", error = ioErrorMsg(lockFileHandleResult.error)
    quit QuitFailure

  let lockFileHandle = lockFile(lockFileHandleResult.value(), LockType.Exclusive)
  if lockFileHandle.isErr():
    fatal "Please ensure no other fluffy instances are running with the same data directory",
      dataDir = config.dataDir
    quit QuitFailure

  let lockFileIoHandle = lockFileHandle.value()
  addExitProc(
    proc() =
      discard unlockFile(lockFileIoHandle)
      discard closeFile(lockFileIoHandle.handle)
  )

  ## Network configuration
  let
    bindIp = config.listenAddress
    udpPort = Port(config.udpPort)
    # TODO: allow for no TCP port mapping!
    (extIp, _, extUdpPort) =
      try:
        setupAddress(config.nat, config.listenAddress, udpPort, udpPort, "fluffy")
      except CatchableError as exc:
        raise exc # TODO: Ideally we don't have the Exception here
      except Exception as exc:
        raiseAssert exc.msg
    (netkey, newNetKey) =
      if config.networkKey.isSome():
        (config.networkKey.get(), true)
      else:
        getPersistentNetKey(rng[], config.networkKeyFile)

    enrFilePath = config.dataDir / "fluffy_node.enr"
    previousEnr =
      if not newNetKey:
        getPersistentEnr(enrFilePath)
      else:
        Opt.none(enr.Record)

  var bootstrapRecords: seq[enr.Record]
  loadBootstrapFile(string config.bootstrapNodesFile, bootstrapRecords)
  bootstrapRecords.add(config.bootstrapNodes)

  case config.network
  of PortalNetwork.none:
    discard # don't connect to any network bootstrap nodes
  of PortalNetwork.mainnet:
    for enrURI in mainnetBootstrapNodes:
      let res = enr.Record.fromURI(enrURI)
      if res.isOk():
        bootstrapRecords.add(res.value)
  of PortalNetwork.angelfood:
    for enrURI in angelfoodBootstrapNodes:
      let res = enr.Record.fromURI(enrURI)
      if res.isOk():
        bootstrapRecords.add(res.value)

  ## Discovery v5 protocol setup
  let
    discoveryConfig = DiscoveryConfig.init(
      config.tableIpLimit, config.bucketIpLimit, config.bitsPerHop, 512
    )
    d = newProtocol(
      netkey,
      extIp,
      Opt.none(Port),
      extUdpPort,
      # Note: The addition of default clientInfo to the ENR is a temporary
      # measure to easily identify & debug the clients used in the testnet.
      # Might make this into a, default off, cli option.
      localEnrFields =
        {"c": enrClientInfoShort, portalVersionKey: SSZ.encode(localSupportedVersions)},
      bootstrapRecords = bootstrapRecords,
      previousRecord = previousEnr,
      bindIp = bindIp,
      bindPort = udpPort,
      enrAutoUpdate = config.enrAutoUpdate,
      config = discoveryConfig,
      rng = rng,
      banNodes = not config.disableBanNodes,
    )

  d.open()

  ## Force pruning - optional
  if config.forcePrune:
    let db = ContentDB.new(
      config.dataDir / config.network.getDbDirectory() / "contentdb_" &
        d.localNode.id.toBytesBE().toOpenArray(0, 8).toHex(),
      storageCapacity = config.storageCapacityMB * 1_000_000,
      radiusConfig = config.radiusConfig,
      localId = d.localNode.id,
      manualCheckpoint = true,
    )

    let radius = db.estimateNewRadius(config.radiusConfig)
    # Note: In the case of dynamical radius this is all an approximation that
    # heavily relies on uniformly distributed content and thus will always
    # have an error margin, either down or up of the requested capacity.
    # TODO I: Perhaps we want to add an offset to counter the latter.
    # TODO II: Perhaps for dynamical radius, we want to also apply the vacuum
    # without the forcePrune flag and purely by checking the amount of free
    # space versus the pruning fraction. The problem with this is that the
    # vacuum will temporarily double the space usage (WAL + DB) and thus to do
    # this automatically without user requesting it could be dangerous.
    # TODO III: Adding Radius metadata to the db could be yet another way to
    # decide whether or not to force prune, instead of this flag.
    db.forcePrune(d.localNode.id, radius)
    db.close()

  ## Portal node setup
  let
    portalProtocolConfig = PortalProtocolConfig.init(
      config.tableIpLimit, config.bucketIpLimit, config.bitsPerHop, config.alpha,
      config.radiusConfig, config.disablePoke, config.maxGossipNodes,
      config.contentCacheSize, config.disableContentCache, config.offerCacheSize,
      config.disableOfferCache, config.maxConcurrentOffers, config.disableBanNodes,
      config.radiusCacheSize,
    )

    portalNodeConfig = PortalNodeConfig(
      accumulatorFile: config.accumulatorFile.optionToOpt().map(
          proc(v: InputFile): string =
            $v
        ),
      disableStateRootValidation: config.disableStateRootValidation,
      trustedBlockRoot: config.trustedBlockRoot.optionToOpt(),
      portalConfig: portalProtocolConfig,
      dataDir: string config.dataDir,
      storageCapacity: config.storageCapacityMB * 1_000_000,
      contentRequestRetries: config.contentRequestRetries.int,
    )

    node = PortalNode.new(
      config.network,
      portalNodeConfig,
      d,
      config.portalSubnetworks,
      bootstrapRecords = bootstrapRecords,
      rng = rng,
    )

  # TODO: If no new network key is generated then we should first check if an
  # enr file exists, and in the case it does read out the seqNum from it and
  # reuse that.
  let enrFile = config.dataDir / "fluffy_node.enr"
  if io2.writeFile(enrFile, d.localNode.record.toURI()).isErr:
    fatal "Failed to write the enr file", file = enrFile
    quit 1

  ## Start metrics HTTP server
  let metricsServer =
    if config.metricsEnabled:
      let
        address = config.metricsAddress
        port = config.metricsPort
        url = "http://" & $address & ":" & $port & "/metrics"

        server = MetricsHttpServerRef.new($address, port).valueOr:
          error "Could not instantiate metrics HTTP server", url, error
          quit QuitFailure

      info "Starting metrics HTTP server", url
      try:
        waitFor server.start()
      except MetricsError as exc:
        fatal "Could not start metrics HTTP server",
          url, error_msg = exc.msg, error_name = exc.name
        quit QuitFailure

      Opt.some(server)
    else:
      Opt.none(MetricsHttpServerRef)

  ## Start the Portal node.
  node.start()

  # For now the Fluffy EVM is only used by the RPC servers so we create the
  # instance here and share it between all the RPC handlers that need it
  let asyncEvm =
    if node.stateNetwork.isSome():
      Opt.some(AsyncEvm.init(node.stateNetwork.get().toAsyncEvmStateBackend()))
    else:
      Opt.none(AsyncEvm)

  ## Start the JSON-RPC APIs

  proc setupRpcServer(
      rpcServer: RpcHttpServer | RpcWebSocketServer, flags: set[RpcFlag]
  ) {.raises: [CatchableError].} =
    for flag in flags:
      case flag
      of RpcFlag.eth:
        rpcServer.installEthApiHandlers(
          node.historyNetwork, node.beaconLightClient, node.stateNetwork, asyncEvm
        )
      of RpcFlag.debug:
        rpcServer.installDebugApiHandlers(node.stateNetwork, asyncEvm)
      of RpcFlag.portal:
        if node.historyNetwork.isSome():
          rpcServer.installPortalCommonApiHandlers(
            node.historyNetwork.value.portalProtocol, PortalSubnetwork.history
          )
          rpcServer.installPortalHistoryApiHandlers(
            node.historyNetwork.value.portalProtocol
          )
        if node.beaconNetwork.isSome():
          rpcServer.installPortalCommonApiHandlers(
            node.beaconNetwork.value.portalProtocol, PortalSubnetwork.beacon
          )
          rpcServer.installPortalBeaconApiHandlers(
            node.beaconNetwork.value.portalProtocol
          )
          rpcServer.installPortalNimbusBeaconApiHandlers(node.beaconNetwork.value)
        if node.stateNetwork.isSome():
          rpcServer.installPortalCommonApiHandlers(
            node.stateNetwork.value.portalProtocol, PortalSubnetwork.state
          )
          rpcServer.installPortalStateApiHandlers(
            node.stateNetwork.value.portalProtocol
          )
      of RpcFlag.portal_debug:
        if node.historyNetwork.isSome():
          rpcServer.installPortalDebugHistoryApiHandlers(
            node.historyNetwork.value.portalProtocol
          )
      of RpcFlag.discovery:
        rpcServer.installDiscoveryApiHandlers(d)

    rpcServer.start()

  let
    rpcFlags = getRpcFlags(config.rpcApi)
    wsFlags = getRpcFlags(config.wsApi)

    rpcHttpServer =
      if config.rpcEnabled:
        let
          ta = initTAddress(config.rpcAddress, config.rpcPort)
          rpcHttpServer = RpcHttpServer.new()
        # 16mb to comfortably fit 2-3mb blocks + blobs + json overhead
        rpcHttpServer.addHttpServer(ta, maxRequestBodySize = 16 * 1024 * 1024)
        rpcHttpServer.setupRpcServer(rpcFlags)

        Opt.some(rpcHttpServer)
      else:
        Opt.none(RpcHttpServer)

    rpcWsServer =
      if config.wsEnabled:
        let
          ta = initTAddress(config.wsAddress, config.wsPort)
          rpcWsServer = newRpcWebSocketServer(ta, compression = config.wsCompression)
        rpcWsServer.setupRpcServer(wsFlags)

        Opt.some(rpcWsServer)
      else:
        Opt.none(RpcWebSocketServer)

  fluffy.status = FluffyStatus.Running
  fluffy.portalNode = node
  fluffy.metricsServer = metricsServer
  fluffy.rpcHttpServer = rpcHttpServer
  fluffy.rpcWsServer = rpcWsServer

proc stop(f: Fluffy) {.async: (raises: []).} =
  if f.rpcWsServer.isSome():
    let server = f.rpcWsServer.get()
    try:
      server.stop()
      await server.closeWait()
    except CatchableError as e:
      warn "Failed to stop rpc WS server", exc = e.name, err = e.msg

  if f.rpcHttpServer.isSome():
    let server = f.rpcHttpServer.get()
    try:
      await server.stop()
      await server.closeWait()
    except CatchableError as e:
      warn "Failed to stop rpc HTTP server", exc = e.name, err = e.msg

  if f.metricsServer.isSome():
    let server = f.metricsServer.get()
    try:
      await server.stop()
      await server.close()
    except CatchableError as e:
      warn "Failed to stop metrics HTTP server", exc = e.name, err = e.msg

  await f.portalNode.stop()

when isMainModule:
  {.pop.}
  let config = PortalConf.load(
    version = clientName & " " & fullVersionStr & "\p\p" & nimBanner,
    copyrightBanner = copyrightBanner,
  )
  {.push raises: [].}

  let fluffy = Fluffy.init()
  case config.cmd
  of PortalCmd.noCommand:
    fluffy.run(config)

  # Ctrl+C handling
  proc controlCHandler() {.noconv.} =
    when defined(windows):
      # workaround for https://github.com/nim-lang/Nim/issues/4057
      try:
        setupForeignThreadGc()
      except Exception as exc:
        raiseAssert exc.msg # shouldn't happen

    notice "Shutting down after having received SIGINT"
    fluffy.status = FluffyStatus.Stopping

  try:
    setControlCHook(controlCHandler)
  except Exception as exc: # TODO Exception
    warn "Cannot set ctrl-c handler", msg = exc.msg

  while fluffy.status == FluffyStatus.Running:
    try:
      poll()
    except CatchableError as e:
      warn "Exception in poll()", exc = e.name, err = e.msg

  waitFor fluffy.stop()
