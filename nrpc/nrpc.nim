# Nimbus
# Copyright (c) 2024-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

{.push raises: [].}

import
  std/[sequtils, os, strformat],
  chronicles,
  chronos/timer,
  ../execution_chain/constants,
  ../execution_chain/core/chain,
  ../execution_chain/core/lazy_kzg,
  ./config,
  ../execution_chain/utils/era_helpers,
    web3,
  web3/[engine_api, primitives, conversions],
  beacon_chain/spec/digest,
  beacon_chain/el/el_conf,
  beacon_chain/el/el_manager,
  beacon_chain/el/engine_api_conversions,
  beacon_chain/spec/[forks, state_transition_block],
  beacon_chain/spec/datatypes/bellatrix,
  beacon_chain/spec/eth2_apis/[rest_types, rest_beacon_calls],
  beacon_chain/networking/network_metadata,
  eth/async_utils

var running* {.volatile.} = true

func f(value: float): string =
  if value >= 1000:
    &"{int(value)}"
  elif value >= 100:
    &"{value:4.1f}"
  elif value >= 10:
    &"{value:4.2f}"
  else:
    &"{value:4.3f}"

# Load the EL block, from CL ( either head or CL root )
template getCLBlockFromBeaconChain(
    client: RestClientRef, blockIdent: BlockIdent, clConfig: RuntimeConfig
): (ForkedSignedBeaconBlock, bool) =
  let clBlock =
    try:
      awaitWithTimeout(client.getBlockV2(blockIdent, clConfig), 30.seconds):
        error "Failed to get CL head"
        quit(QuitFailure)
    except CatchableError as exc:
      error "Error getting CL head", error = exc.msg
      quit(QuitFailure)

  # Constructing the EL block from the CL block
  var blck: ForkedSignedBeaconBlock
  if clBlock.isSome():
    let blck = clBlock.get()[]
    (blck, true)
  else:
    (blck, false)

# Load the EL block, from CL ( either head or CL root )
# Also returns the availability of the block as a boolean
template getELBlockFromBeaconChain(
    client: RestClientRef, blockIdent: BlockIdent, clConfig: RuntimeConfig
): (EthBlock, bool) =
  let (clBlock, isAvailable) = getCLBlockFromBeaconChain(client, blockIdent, clConfig)

  # Constructing the EL block from the CL block
  var eth1block: EthBlock
  if isAvailable:
    withBlck(clBlock.asTrusted()):
      if not getEthBlock(forkyBlck.message, eth1Block):
        error "Failed to get EL block from CL head"
        quit(QuitFailure)

    (eth1Block, true)
  else:
    (eth1Block, false)

# Load the network configuration based on the network id
template loadNetworkConfig(conf: NRpcConf): (RuntimeConfig, uint64, uint64) =
  if conf.networkId == MainNet:
    (getMetadataForNetwork("mainnet").cfg, 15537393'u64, 4700013'u64)
  elif conf.networkId == SepoliaNet:
    (getMetadataForNetwork("sepolia").cfg, 1450408'u64, 115193'u64)
  elif conf.networkId == HoleskyNet:
    (getMetadataForNetwork("holesky").cfg, 0'u64, 0'u64)
  elif conf.networkId == HoodiNet:
    (getMetadataForNetwork("hoodi").cfg, 0'u64, 0'u64)
  else:
    notice "Loading custom network, assuming post-merge"
    if conf.customNetworkFolder.len == 0:
      error "Custom network file not provided"
      quit(QuitFailure)
    let (cfg, unloaded) = readRuntimeConfig(conf.customNetworkFolder.joinPath("config.yaml"))
    debug "Fields unknown", unloaded = unloaded
    (cfg, 0'u64, 0'u64)


# Slot Finding Mechanism
# First it sets the initial lower bound to `firstSlotAfterMerge` + number of blocks after Era1
# Then it iterates over the slots to find the current slot number, along with reducing the
# search space by calculating the difference between the `blockNumber` and the `block_number` from the executionPayload
# of the slot, then adding the difference to the importedSlot. This pushes the lower bound more,
# making the search way smaller
template findSlot(
    client: RestClientRef,
    currentBlockNumber: uint64,
    lastEra1Block: uint64,
    firstSlotAfterMerge: uint64,
): uint64 =
  var importedSlot = (currentBlockNumber - lastEra1Block) + firstSlotAfterMerge
  notice "Finding slot number corresponding to block", importedSlot = importedSlot

  var clNum = 0'u64
  while running and clNum < currentBlockNumber:
    let (blk, stat) =
      client.getELBlockFromBeaconChain(BlockIdent.init(Slot(importedSlot)), clConfig)
    if not stat:
      importedSlot += 1
      continue

    clNum = blk.header.number
    # decreasing the lower bound with each iteration
    importedSlot += currentBlockNumber - clNum

  notice "Found the slot to start with", slot = importedSlot
  importedSlot

# The main procedure to sync the EL with the help of CL
# Takes blocks from the CL and sends them to the EL via the engineAPI
proc syncToEngineApi(conf: NRpcConf) {.async.} =
  let
    # Load the network configuration, jwt secret and engine api url
    (clConfig, lastEra1Block, firstSlotAfterMerge) = loadNetworkConfig(conf)
    jwtSecret =
      if conf.jwtSecret.isSome():
        loadJwtSecret(Opt.some(conf.jwtSecret.get()))
      else:
        Opt.none(seq[byte])
    engineUrl = EngineApiUrl.init(conf.elEngineApi, jwtSecret)

    # Create the client for the engine api
    # And exchange the capabilities for a test communication
    web3 = await engineUrl.newWeb3()
    rpcClient = web3.provider

  try:
    let data = await rpcClient.exchangeCapabilities(
      @[
        "engine_forkchoiceUpdatedV1", "engine_getPayloadBodiesByHash",
        "engine_getPayloadBodiesByRangeV1", "engine_getPayloadV1", "engine_newPayloadV1",
      ]
    )
    notice "Communication with the EL Success", data = data
  except CatchableError as exc:
    error "Error connecting to the EL Engine API", error = exc.msg
    quit(QuitFailure)

  # Get the latest block number from the EL rest api
  template elBlockNumber(): uint64 =
    try:
      uint64(await rpcClient.eth_blockNumber())
    except CatchableError as exc:
      error "Error getting block number", error = exc.msg
      quit(QuitFailure)

  # Load the EL state detials and create the beaconAPI client
  var
    currentBlockNumber = elBlockNumber() + 1
    curBlck: ForkedSignedBeaconBlock
    client = RestClientRef.new(conf.beaconApi).valueOr:
      error "Cannot connect to Beacon Api", url = conf.beaconApi
      quit(QuitFailure)

  notice "Current block number", number = currentBlockNumber

  # Check for pre-merge situation
  if currentBlockNumber <= lastEra1Block:
    notice "Pre-merge, nrpc syncer works post-merge",
      blocknumber = currentBlockNumber, lastPoWBlock = lastEra1Block
    quit(QuitSuccess)

  # Load the latest state from the CL
  var
    (finalizedBlck, _) = client.getELBlockFromBeaconChain(
      BlockIdent.init(BlockIdentType.Finalized), clConfig
    )
    (headBlck, _) =
      client.getELBlockFromBeaconChain(BlockIdent.init(BlockIdentType.Head), clConfig)

  # Check if the EL is already in sync or ahead of the CL
  if headBlck.header.number <= currentBlockNumber:
    notice "CL head is behind of EL head, or in sync", head = headBlck.header.number
    quit(QuitSuccess)

  var
    importedSlot =
      findSlot(client, currentBlockNumber, lastEra1Block, firstSlotAfterMerge)
    finalizedHash = Eth2Digest.fromHex("0x00")
    headHash: Eth2Digest

    # Required for progress tracker
    time = Moment.now()
    progressTrackedHead = currentBlockNumber

  template estimateProgressForSync() =
    let 
      blocks = int(currentBlockNumber - progressTrackedHead)
      curTime = Moment.now()
      diff = curTime - time
      diffSecs = diff.nanoseconds().float / 1000000000
      targetBlkNum = headBlck.header.number
      distance = targetBlkNum - currentBlockNumber
      estimatedTime = (diff*int(distance)).div(blocks)

    notice "Estimated Progress",
      remainingBlocks = distance,
      targetBlockNumber = targetBlkNum,
      bps = f(blocks.float / diffSecs),
      timeToSync = toString(estimatedTime, 2)

    #reset
    time = Moment.now()
    progressTrackedHead = currentBlockNumber

  template sendFCU(clblk: ForkedSignedBeaconBlock) =
    withBlck(clblk):
      let
        state = ForkchoiceStateV1(
          headBlockHash: headHash.asBlockHash,
          safeBlockHash: finalizedHash.asBlockHash,
          finalizedBlockHash: finalizedHash.asBlockHash,
        )
        payloadAttributes =
          when consensusFork <= ConsensusFork.Bellatrix:
            Opt.none(PayloadAttributesV1)
          elif consensusFork == ConsensusFork.Capella:
            Opt.none(PayloadAttributesV2)
          elif consensusFork == ConsensusFork.Deneb or
            consensusFork == ConsensusFork.Electra or consensusFork == ConsensusFork.Fulu:
            Opt.none(PayloadAttributesV3)
          else:
            static:
              doAssert(false, "Unsupported consensus fork")
            Opt.none(PayloadAttributesV3)

      # Make the forkchoiceUpdated call based, after loading attributes based on the consensus fork
      let fcuResponse = await rpcClient.forkchoiceUpdated(state, payloadAttributes)
      debug "forkchoiceUpdated", state = state, response = fcuResponse
      if fcuResponse.payloadStatus.status == PayloadExecutionStatus.invalid or
          fcuResponse.payloadStatus.status == PayloadExecutionStatus.invalid_block_hash:
        error "Forkchoice not validated", status = fcuResponse.payloadStatus.status
        quit(QuitFailure)
      else:
        info "forkchoiceUpdated Request sent",
          response = fcuResponse.payloadStatus.status

    estimateProgressForSync()

  while running and currentBlockNumber < headBlck.header.number:
    var isAvailable = false
    (curBlck, isAvailable) =
      client.getCLBlockFromBeaconChain(BlockIdent.init(Slot(importedSlot)), clConfig)

    if not isAvailable:
      importedSlot += 1
      continue

    importedSlot += 1
    withBlck(curBlck):
      # Don't include blocks before bellatrix, as it doesn't have payload
      when consensusFork >= ConsensusFork.Bellatrix:
        # Load the execution payload for all blocks after the bellatrix upgrade
        let payload = forkyBlck.message.body.asEngineExecutionPayload()
        var payloadResponse: engine_api.PayloadStatusV1

        # Make the newPayload call based on the consensus fork
        # Before Deneb calls are made without versioned hashes
        # Thus calls will be same for Bellatrix and Capella forks
        # And for Deneb, we will pass the versioned hashes
        when consensusFork <= ConsensusFork.Capella:
          payloadResponse = await rpcClient.newPayload(payload)
          debug "Payload status", response = payloadResponse, payload = payload
        elif consensusFork == ConsensusFork.Deneb:
          # Calculate the versioned hashes from the kzg commitments
          let versioned_hashes = mapIt(
            forkyBlck.message.body.blob_kzg_commitments,
            engine_api.VersionedHash(kzg_commitment_to_versioned_hash(it)),
          )
          payloadResponse = await rpcClient.newPayload(
            payload, versioned_hashes, forkyBlck.message.parent_root.to(Hash32)
          )
          debug "Payload status",
            response = payloadResponse,
            payload = payload,
            versionedHashes = versioned_hashes
        elif consensusFork == ConsensusFork.Electra or
            consensusFork == ConsensusFork.Fulu:
          let
            # Calculate the versioned hashes from the kzg commitments
            versioned_hashes = mapIt(
              forkyBlck.message.body.blob_kzg_commitments,
              engine_api.VersionedHash(kzg_commitment_to_versioned_hash(it)),
            )
            # Execution Requests for Electra
            execution_requests = block:
              var requests: seq[seq[byte]]
              for request_type, request_data in [
                SSZ.encode(forkyBlck.message.body.execution_requests.deposits),
                SSZ.encode(forkyBlck.message.body.execution_requests.withdrawals),
                SSZ.encode(forkyBlck.message.body.execution_requests.consolidations),
              ]:
                if request_data.len > 0:
                  requests.add @[request_type.byte] & request_data
              requests

          payloadResponse = await rpcClient.engine_newPayloadV4(
            payload,
            versioned_hashes,
            forkyBlck.message.parent_root.to(Hash32),
            execution_requests,
          )
          debug "Payload status",
            response = payloadResponse,
            payload = payload,
            versionedHashes = versioned_hashes,
            executionRequests = execution_requests
        else:
          static:
            doAssert(false, "Unsupported consensus fork")

        info "newPayload Request sent",
          blockNumber = int(payload.blockNumber), response = payloadResponse.status

        if payloadResponse.status == PayloadExecutionStatus.invalid or
            payloadResponse.status == PayloadExecutionStatus.invalid_block_hash:
          error "Payload not validated",
            blockNumber = int(payload.blockNumber), status = payloadResponse.status
          quit(QuitFailure)

        # Load the head hash from the execution payload, for forkchoice
        headHash = forkyBlck.message.body.execution_payload.block_hash

        # Update the finalized hash
        # This is updated after the fcu call is made
        # So that head - head mod 32 is maintained
        # i.e finalized have to be mod slots per epoch == 0
        let blknum = forkyBlck.message.body.execution_payload.block_number
        if blknum < finalizedBlck.header.number and blknum mod 32 == 0:
          finalizedHash = headHash
          # Make the forkchoicestate based on the the last
          # `new_payload` call and the state received from the EL JSON-RPC API
          # And generate the PayloadAttributes based on the consensus fork
          sendFCU(curBlck)
        elif blknum >= finalizedBlck.header.number:
          # If the real finalized block is crossed, then upate the finalized hash to the real one
          (finalizedBlck, _) = client.getELBlockFromBeaconChain(
            BlockIdent.init(BlockIdentType.Finalized), clConfig
          )
          finalizedHash = finalizedBlck.header.computeBlockHash.asEth2Digest

    # Update the current block number from EL rest api
    # Shows that the fcu call has succeeded
    currentBlockNumber = elBlockNumber()
    let oldHeadBlockNumber = headBlck.header.number
    (headBlck, _) =
      client.getELBlockFromBeaconChain(BlockIdent.init(BlockIdentType.Head), clConfig)

    # Check for reorg
    # No need to check for reorg if the EL head is behind the finalized block
    if currentBlockNumber > finalizedBlck.header.number and
        oldHeadBlockNumber > headBlck.header.number:
      warn "Head moved backwards : Possible reorg detected",
        oldHead = oldHeadBlockNumber, newHead = headBlck.header.number

      let (headClBlck, isAvailable) =
        client.getCLBlockFromBeaconChain(BlockIdent.init(BlockIdentType.Head), clConfig)

      # move back the importedSlot to the finalized block
      if isAvailable:
        withBlck(headClBlck.asTrusted()):
          when consensusFork >= ConsensusFork.Bellatrix:
            importedSlot = forkyBlck.message.slot.uint64 + 1
            currentBlockNumber = forkyBlck.message.body.execution_payload.block_number

          # Load this head to the `headBlck`
          if not getEthBlock(forkyBlck.message, headBlck):
            error "Failed to get EL block from CL head"
            quit(QuitFailure)

        (finalizedBlck, _) = client.getELBlockFromBeaconChain(
          BlockIdent.init(BlockIdentType.Finalized), clConfig
        )
        finalizedHash = finalizedBlck.header.computeBlockHash.asEth2Digest
        sendFCU(headClBlck)
      else:
        error "Failed to get CL head"
        quit(QuitFailure)

  # fcU call for the last remaining payloads
  sendFCU(curBlck)

when isMainModule:
  ## Ctrl+C handling
  proc controlCHandler() {.noconv.} =
    when defined(windows):
      # workaround for https://github.com/nim-lang/Nim/issues/4057
      setupForeignThreadGc()
    running = false

  setControlCHook(controlCHandler)

  ## Show logs on stdout until we get the user's logging choice
  discard defaultChroniclesStream.output.open(stdout)

  ## Processing command line arguments
  let conf = makeConfig()
  setLogLevel(conf.logLevel)

  case conf.cmd
  of NRpcCmd.`sync`:
    waitFor syncToEngineApi(conf)
