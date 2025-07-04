# Nimbus
# Copyright (c) 2022-2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.push raises: [].}

import
  chronicles,
  metrics,
  eth/db/kvstore,
  eth/db/kvstore_sqlite3,
  stint,
  results,
  ssz_serialization,
  beacon_chain/db_utils,
  beacon_chain/spec/forks,
  beacon_chain/spec/forks_light_client,
  ./beacon_content,
  ./beacon_chain_historical_summaries,
  ./beacon_init_loader,
  ../wire/[portal_protocol, portal_protocol_config]

from beacon_chain/spec/helpers import is_better_update, toMeta

export kvstore_sqlite3, beacon_chain_historical_summaries, beacon_content

type
  BestLightClientUpdateStore = ref object
    getStmt: SqliteStmt[int64, seq[byte]]
    getBulkStmt: SqliteStmt[(int64, int64), seq[byte]]
    putStmt: SqliteStmt[(int64, seq[byte]), void]
    delStmt: SqliteStmt[int64, void]
    keepFromStmt: SqliteStmt[int64, void]

  BootstrapStore = ref object
    getStmt: SqliteStmt[array[32, byte], seq[byte]]
    getLatestStmt: SqliteStmt[NoParams, seq[byte]]
    putStmt: SqliteStmt[(array[32, byte], seq[byte], int64), void]
    keepFromStmt: SqliteStmt[int64, void]

  HistoricalSummariesStore = ref object
    getStmt: SqliteStmt[int64, seq[byte]]
    getLatestStmt: SqliteStmt[NoParams, seq[byte]]
    putStmt: SqliteStmt[(int64, seq[byte]), void]
    keepFromStmt: SqliteStmt[int64, void]

  BeaconDb* = ref object
    backend: SqStoreRef
    kv: KvStoreRef
    dataRadius*: UInt256
    bootstraps: BootstrapStore
    bestUpdates: BestLightClientUpdateStore
    historicalSummaries: HistoricalSummariesStore
    forkDigests: ForkDigests
    cfg*: RuntimeConfig
    beaconDbCache*: BeaconDbCache

  BeaconDbCache* = ref object
    finalityUpdateCache*: Opt[LightClientFinalityUpdateCache]
    optimisticUpdateCache*: Opt[LightClientOptimisticUpdateCache]
    historicalSummariesCache*: Opt[HistoricalSummariesWithProof]

  # Storing the content encoded here. Could also store decoded and access the
  # slot directly. However, that would require is to have access to the
  # fork digests here to be able the re-encode the data.
  LightClientFinalityUpdateCache = object
    latestFinalityUpdate: seq[byte]
    latestFinalityUpdateSlot: uint64

  LightClientOptimisticUpdateCache = object
    latestOptimisticUpdate: seq[byte]
    latestOptimisticUpdateSlot: uint64

template expectDb(x: auto): untyped =
  # There's no meaningful error handling implemented for a corrupt database or
  # full disk - this requires manual intervention, so we'll panic for now
  x.expect("working database (disk broken/full?)")

template disposeSafe(s: untyped): untyped =
  if distinctBase(s) != nil:
    s.dispose()
    s = typeof(s)(nil)

proc initBootstrapStore(backend: SqStoreRef, name: string): KvResult[BootstrapStore] =
  ?backend.exec(
    """
    CREATE TABLE IF NOT EXISTS `""" & name &
      """` (
      `contentId` BLOB PRIMARY KEY, -- `ContentId`
      `bootstrap` BLOB,             -- `LightClientBootstrap` (SSZ)
      `slot` INTEGER UNIQUE         -- `Slot`
    );
  """
  )

  let
    getStmt = backend
      .prepareStmt(
        """
        SELECT `bootstrap`
        FROM `""" & name &
          """`
        WHERE `contentId` = ?;
      """,
        array[32, byte],
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    getLatestStmt = backend
      .prepareStmt(
        """
        SELECT `bootstrap`
        FROM `""" & name &
          """`
        WHERE `slot` = (SELECT MAX(slot) FROM `""" & name &
          """`);
      """,
        NoParams,
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    putStmt = backend
      .prepareStmt(
        """
        REPLACE INTO `""" & name &
          """` (
        `contentId`, `bootstrap`, `slot`
        ) VALUES (?, ?, ?);
      """,
        (array[32, byte], seq[byte], int64),
        void,
        managed = false,
      )
      .expect("SQL query OK")
    keepFromStmt = backend
      .prepareStmt(
        """
        DELETE FROM `""" & name &
          """`
        WHERE `slot` < ?;
      """,
        int64,
        void,
        managed = false,
      )
      .expect("SQL query OK")

  ok BootstrapStore(
    getStmt: getStmt,
    getLatestStmt: getLatestStmt,
    putStmt: putStmt,
    keepFromStmt: keepFromStmt,
  )

proc initBestUpdateStore(
    backend: SqStoreRef, name: string
): KvResult[BestLightClientUpdateStore] =
  ?backend.exec(
    """
    CREATE TABLE IF NOT EXISTS `""" & name &
      """` (
      `period` INTEGER PRIMARY KEY,  -- `SyncCommitteePeriod`
      `update` BLOB                  -- `LightClientUpdate` (SSZ)
    );
  """
  )

  let
    getStmt = backend
      .prepareStmt(
        """
        SELECT `update`
        FROM `""" & name &
          """`
        WHERE `period` = ?;
      """,
        int64,
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    getBulkStmt = backend
      .prepareStmt(
        """
        SELECT `update`
        FROM `""" & name &
          """`
        WHERE `period` >= ? AND `period` < ?;
      """,
        (int64, int64),
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    putStmt = backend
      .prepareStmt(
        """
        REPLACE INTO `""" & name &
          """` (
          `period`, `update`
        ) VALUES (?, ?);
      """,
        (int64, seq[byte]),
        void,
        managed = false,
      )
      .expect("SQL query OK")
    delStmt = backend
      .prepareStmt(
        """
        DELETE FROM `""" & name &
          """`
        WHERE `period` = ?;
      """,
        int64,
        void,
        managed = false,
      )
      .expect("SQL query OK")
    keepFromStmt = backend
      .prepareStmt(
        """
        DELETE FROM `""" & name &
          """`
        WHERE `period` < ?;
      """,
        int64,
        void,
        managed = false,
      )
      .expect("SQL query OK")

  ok BestLightClientUpdateStore(
    getStmt: getStmt,
    getBulkStmt: getBulkStmt,
    putStmt: putStmt,
    delStmt: delStmt,
    keepFromStmt: keepFromStmt,
  )

proc initHistoricalSummariesStore(
    backend: SqStoreRef, name: string
): KvResult[HistoricalSummariesStore] =
  ?backend.exec(
    """
    CREATE TABLE IF NOT EXISTS `""" & name &
      """` (
      `epoch` INTEGER PRIMARY KEY,   -- `historical_summaries` epoch
      `summaries` BLOB               -- `HistoricalSummariesWithProof` (SSZ)
    );
  """
  )

  let
    getStmt = backend
      .prepareStmt(
        """
        SELECT `summaries`
        FROM `""" & name &
          """`
        WHERE `epoch` = ?;
      """,
        int64,
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    getLatestStmt = backend
      .prepareStmt(
        """
        SELECT `summaries`
        FROM `""" & name &
          """`
        WHERE `epoch` = (SELECT MAX(epoch) FROM `""" & name &
          """`);
      """,
        NoParams,
        seq[byte],
        managed = false,
      )
      .expect("SQL query OK")
    putStmt = backend
      .prepareStmt(
        """
        REPLACE INTO `""" & name &
          """` (
          `epoch`, `summaries`
        ) VALUES (?, ?);
      """,
        (int64, seq[byte]),
        void,
        managed = false,
      )
      .expect("SQL query OK")
    keepFromStmt = backend
      .prepareStmt(
        """
        DELETE FROM `""" & name &
          """`
        WHERE `epoch` < ?;
      """,
        int64,
        void,
        managed = false,
      )
      .expect("SQL query OK")

  ok HistoricalSummariesStore(
    getStmt: getStmt,
    getLatestStmt: getLatestStmt,
    putStmt: putStmt,
    keepFromStmt: keepFromStmt,
  )

func close(store: var BestLightClientUpdateStore) =
  store.getStmt.disposeSafe()
  store.getBulkStmt.disposeSafe()
  store.putStmt.disposeSafe()
  store.delStmt.disposeSafe()
  store.keepFromStmt.disposeSafe()

func close(store: var BootstrapStore) =
  store.getStmt.disposeSafe()
  store.getLatestStmt.disposeSafe()
  store.putStmt.disposeSafe()
  store.keepFromStmt.disposeSafe()

func close(store: var HistoricalSummariesStore) =
  store.getStmt.disposeSafe()
  store.getLatestStmt.disposeSafe()
  store.putStmt.disposeSafe()
  store.keepFromStmt.disposeSafe()

proc new*(
    T: type BeaconDb, networkData: NetworkInitData, path: string, inMemory = false
): BeaconDb =
  let
    db =
      if inMemory:
        SqStoreRef.init("", "lc-test", inMemory = true).expect(
          "working database (out of memory?)"
        )
      else:
        SqStoreRef.init(path, "lc").expectDb()

    kvStore = kvStore db.openKvStore().expectDb()
    bootstraps = initBootstrapStore(db, "lc_bootstraps").expectDb()
    bestUpdates = initBestUpdateStore(db, "lc_best_updates").expectDb()
    historicalSummaries =
      initHistoricalSummariesStore(db, "beacon_historical_summaries").expectDb()

  BeaconDb(
    backend: db,
    kv: kvStore,
    dataRadius: UInt256.high(), # Radius to max to accept all data
    bootstraps: bootstraps,
    bestUpdates: bestUpdates,
    historicalSummaries: historicalSummaries,
    cfg: networkData.metadata.cfg,
    forkDigests: (newClone networkData.forks)[],
    beaconDbCache: BeaconDbCache(),
  )

proc close*(db: BeaconDb) =
  db.bootstraps.close()
  db.bestUpdates.close()
  db.historicalSummaries.close()

  discard db.kv.close()

  db.backend.close()
  db.backend = nil

template finalityUpdateCache(db: BeaconDb): Opt[LightClientFinalityUpdateCache] =
  db.beaconDbCache.finalityUpdateCache

template optimisticUpdateCache(db: BeaconDb): Opt[LightClientOptimisticUpdateCache] =
  db.beaconDbCache.optimisticUpdateCache

template historicalSummariesCache(db: BeaconDb): Opt[HistoricalSummariesWithProof] =
  db.beaconDbCache.historicalSummariesCache

## Private KvStoreRef Calls
proc get(kv: KvStoreRef, key: openArray[byte]): results.Opt[seq[byte]] =
  var res: results.Opt[seq[byte]] = Opt.none(seq[byte])
  proc onData(data: openArray[byte]) =
    res = ok(@data)

  discard kv.get(key, onData).expectDb()

  return res

## Private BeaconDb calls
proc get(db: BeaconDb, key: openArray[byte]): results.Opt[seq[byte]] =
  db.kv.get(key)

proc put(db: BeaconDb, key, value: openArray[byte]) =
  db.kv.put(key, value).expectDb()

## Public ContentId based ContentDB calls
proc get*(db: BeaconDb, key: ContentId): results.Opt[seq[byte]] =
  # TODO: Here it is unfortunate that ContentId is a uint256 instead of Digest256.
  db.get(key.toBytesBE())

proc put*(db: BeaconDb, key: ContentId, value: openArray[byte]) =
  db.put(key.toBytesBE(), value)

# TODO Add checks that uint64 can be safely casted to int64
proc getLightClientUpdates(
    db: BeaconDb, start: uint64, to: uint64
): ForkedLightClientUpdateBytesList =
  ## Get multiple consecutive LightClientUpdates for given periods
  var updates: ForkedLightClientUpdateBytesList
  var update: seq[byte]
  for res in db.bestUpdates.getBulkStmt.exec((start.int64, to.int64), update):
    res.expect("SQL query OK")
    let byteList = List[byte, MAX_LIGHT_CLIENT_UPDATE_SIZE].init(update)
    discard updates.add(byteList)
  return updates

proc getBestUpdate*(
    db: BeaconDb, period: SyncCommitteePeriod
): Result[ForkedLightClientUpdate, string] =
  ## Get the best ForkedLightClientUpdate for given period
  ## Note: Only the best one for a given period is being stored.
  doAssert period.isSupportedBySQLite
  doAssert distinctBase(db.bestUpdates.getStmt) != nil

  var update: seq[byte]
  for res in db.bestUpdates.getStmt.exec(period.int64, update):
    res.expect("SQL query OK")
    return decodeLightClientUpdateForked(db.forkDigests, update)

proc getBootstrap*(db: BeaconDb, contentId: ContentId): Opt[seq[byte]] =
  doAssert distinctBase(db.bootstraps.getStmt) != nil

  var bootstrap: seq[byte]
  for res in db.bootstraps.getStmt.exec(contentId.toBytesBE(), bootstrap):
    res.expect("SQL query OK")
    return ok(bootstrap)

proc getLatestBootstrap*(db: BeaconDb): Opt[ForkedLightClientBootstrap] =
  doAssert distinctBase(db.bootstraps.getLatestStmt) != nil

  var bootstrap: seq[byte]
  for res in db.bootstraps.getLatestStmt.exec(bootstrap):
    res.expect("SQL query OK")
    let forkedBootstrap = decodeLightClientBootstrapForked(db.forkDigests, bootstrap).valueOr:
      raiseAssert "Stored bootstrap must be valid"
    return ok(forkedBootstrap)

proc getLatestBlockRoot*(db: BeaconDb): Opt[Digest] =
  let bootstrap = db.getLatestBootstrap()
  if bootstrap.isSome():
    withForkyBootstrap(bootstrap.value()):
      when lcDataFork > LightClientDataFork.None:
        Opt.some(hash_tree_root(forkyBootstrap.header.beacon))
      else:
        raiseAssert "Stored bootstrap must >= Altair"
  else:
    Opt.none(Digest)

proc putBootstrap*(
    db: BeaconDb, contentId: ContentId, bootstrap: seq[byte], slot: Slot
) =
  db.bootstraps.putStmt.exec((contentId.toBytesBE(), bootstrap, slot.int64)).expect(
    "SQL query OK"
  )

proc putBootstrap*(
    db: BeaconDb, blockRoot: Digest, bootstrap: ForkedLightClientBootstrap
) =
  # Put a ForkedLightClientBootstrap in the db.
  withForkyBootstrap(bootstrap):
    when lcDataFork > LightClientDataFork.None:
      let
        contentKey = bootstrapContentKey(blockRoot)
        contentId = toContentId(contentKey)
        forkDigest = forkDigestAtEpoch(
          db.forkDigests, epoch(forkyBootstrap.header.beacon.slot), db.cfg
        )
        encodedBootstrap = encodeBootstrapForked(forkDigest, bootstrap)

      db.putBootstrap(contentId, encodedBootstrap, forkyBootstrap.header.beacon.slot)

func putLightClientUpdate*(db: BeaconDb, period: uint64, update: seq[byte]) =
  # Put an encoded ForkedLightClientUpdate in the db.
  let res = db.bestUpdates.putStmt.exec((period.int64, update))
  res.expect("SQL query OK")

func putBestUpdate*(
    db: BeaconDb, period: SyncCommitteePeriod, update: ForkedLightClientUpdate
) =
  # Put a ForkedLightClientUpdate in the db.
  doAssert not db.backend.readOnly # All `stmt` are non-nil
  doAssert period.isSupportedBySQLite
  withForkyUpdate(update):
    when lcDataFork > LightClientDataFork.None:
      let numParticipants = forkyUpdate.sync_aggregate.num_active_participants
      if numParticipants < MIN_SYNC_COMMITTEE_PARTICIPANTS:
        let res = db.bestUpdates.delStmt.exec(period.int64)
        res.expect("SQL query OK")
      else:
        let
          forkDigest = forkDigestAtEpoch(
            db.forkDigests, epoch(forkyUpdate.attested_header.beacon.slot), db.cfg
          )
          encodedUpdate = encodeForkedLightClientObject(update, forkDigest)
          res = db.bestUpdates.putStmt.exec((period.int64, encodedUpdate))
        res.expect("SQL query OK")
    else:
      db.bestUpdates.delStmt.exec(period.int64).expect("SQL query OK")

proc putUpdateIfBetter*(
    db: BeaconDb, period: SyncCommitteePeriod, update: ForkedLightClientUpdate
) =
  let currentUpdate = db.getBestUpdate(period).valueOr:
    # No current update for that period so we can just put this one
    db.putBestUpdate(period, update)
    return

  if is_better_update(update, currentUpdate):
    db.putBestUpdate(period, update)

proc putUpdateIfBetter*(db: BeaconDb, period: SyncCommitteePeriod, update: seq[byte]) =
  let newUpdate = decodeLightClientUpdateForked(db.forkDigests, update).valueOr:
    # TODO:
    # Need to go over the usage in offer/accept vs findcontent/content
    # and in some (all?) decoding has already been verified.
    return

  db.putUpdateIfBetter(period, newUpdate)

proc getLastFinalityUpdate*(db: BeaconDb): Opt[ForkedLightClientFinalityUpdate] =
  db.finalityUpdateCache.map(
    proc(x: LightClientFinalityUpdateCache): ForkedLightClientFinalityUpdate =
      decodeLightClientFinalityUpdateForked(db.forkDigests, x.latestFinalityUpdate).valueOr:
        raiseAssert "Stored finality update must be valid"
  )

func keepUpdatesFrom*(db: BeaconDb, minPeriod: SyncCommitteePeriod) =
  let res = db.bestUpdates.keepFromStmt.exec(minPeriod.int64)
  res.expect("SQL query OK")

func keepBootstrapsFrom*(db: BeaconDb, minSlot: Slot) =
  let res = db.bootstraps.keepFromStmt.exec(minSlot.int64)
  res.expect("SQL query OK")

proc getLatestHistoricalSummaries*(db: BeaconDb): Opt[seq[byte]] =
  doAssert distinctBase(db.historicalSummaries.getLatestStmt) != nil

  var summaries: seq[byte]
  for res in db.historicalSummaries.getLatestStmt.exec(summaries):
    res.expect("SQL query OK")
    return ok(summaries)

func loadHistoricalSummariesCache*(db: BeaconDb) =
  let summariesEncoded = db.getLatestHistoricalSummaries().valueOr:
    return

  let summariesWithProof = decodeSsz(
    db.forkDigests, summariesEncoded, HistoricalSummariesWithProof
  ).valueOr:
    raiseAssert "Stored historical summaries must be valid"

  db.beaconDbCache.historicalSummariesCache = Opt.some(summariesWithProof)

func putHistoricalSummaries(db: BeaconDb, summaries: seq[byte], epoch: Epoch) =
  db.historicalSummaries.putStmt.exec((epoch.int64, summaries)).expect("SQL query OK")

func keepHistoricalSummariesFrom(db: BeaconDb, epoch: Epoch) =
  db.historicalSummaries.keepFromStmt.exec(epoch.int64).expect("SQL query OK")

func putLatestHistoricalSummaries(db: BeaconDb, summaries: seq[byte]) =
  let summariesWithProof = decodeSsz(
    db.forkDigests, summaries, HistoricalSummariesWithProof
  ).valueOr:
    raiseAssert "Stored historical summaries must have been validated"

  if db.historicalSummariesCache.isNone() or
      db.historicalSummariesCache.value().epoch < summariesWithProof.epoch:
    # Store in cache in its decoded form
    db.beaconDbCache.historicalSummariesCache = Opt.some(summariesWithProof)
    # Store in db
    db.putHistoricalSummaries(summaries, Epoch(summariesWithProof.epoch))
    # Delete old summaries
    db.keepHistoricalSummariesFrom(Epoch(summariesWithProof.epoch))

proc getHandlerImpl(
    db: BeaconDb, contentKey: ContentKeyByteList, contentId: ContentId
): results.Opt[seq[byte]] =
  let contentKey = contentKey.decode().valueOr:
    # TODO: as this should not fail, maybe it is better to raiseAssert ?
    return Opt.none(seq[byte])

  case contentKey.contentType
  of unused:
    raiseAssert "Should not be used and fail at decoding"
  of lightClientBootstrap:
    db.getBootstrap(contentId)
  of lightClientUpdate:
    let
      # TODO: add validation that startPeriod is not from the future,
      # this requires db to be aware off the current beacon time
      startPeriod = contentKey.lightClientUpdateKey.startPeriod
      # get max 128 updates
      numOfUpdates = min(
        uint64(MAX_REQUEST_LIGHT_CLIENT_UPDATES), contentKey.lightClientUpdateKey.count
      )
      toPeriod = startPeriod + numOfUpdates # Not inclusive
      updates = db.getLightClientUpdates(startPeriod, toPeriod)

    if len(updates) == 0:
      Opt.none(seq[byte])
    else:
      # Note that this might not return all of the requested updates.
      # This might seem faulty/tricky as it is also used in handleOffer to
      # check if an offer should be accepted.
      # But it is actually fine as this will occur only when the node is
      # synced and it would not be able to verify the older updates in the
      # range anyhow.
      Opt.some(SSZ.encode(updates))
  of lightClientFinalityUpdate:
    # TODO:
    # Return only when the update is better than what is requested by
    # contentKey. This is currently not possible as the contentKey does not
    # include best update information.
    if db.finalityUpdateCache.isSome():
      let slot = contentKey.lightClientFinalityUpdateKey.finalizedSlot
      let cache = db.finalityUpdateCache.get()
      if cache.latestFinalityUpdateSlot >= slot:
        Opt.some(cache.latestFinalityUpdate)
      else:
        Opt.none(seq[byte])
    else:
      Opt.none(seq[byte])
  of lightClientOptimisticUpdate:
    # TODO same as above applies here too.
    if db.optimisticUpdateCache.isSome():
      let slot = contentKey.lightClientOptimisticUpdateKey.optimisticSlot
      let cache = db.optimisticUpdateCache.get()
      if cache.latestOptimisticUpdateSlot >= slot:
        Opt.some(cache.latestOptimisticUpdate)
      else:
        Opt.none(seq[byte])
    else:
      Opt.none(seq[byte])
  of beacon_content.ContentType.historicalSummaries:
    if db.historicalSummariesCache.isSome() and
        db.historicalSummariesCache.value().epoch >=
        contentKey.historicalSummariesKey.epoch:
      db.getLatestHistoricalSummaries()
    else:
      Opt.none(seq[byte])

proc createGetHandler*(db: BeaconDb): DbGetHandler =
  return (
    proc(contentKey: ContentKeyByteList, contentId: ContentId): results.Opt[seq[byte]] =
      db.getHandlerImpl(contentKey, contentId)
  )

proc createStoreHandler*(db: BeaconDb): DbStoreHandler =
  return (
    proc(
        contentKey: ContentKeyByteList, contentId: ContentId, content: seq[byte]
    ): bool {.raises: [], gcsafe.} =
      let contentKey = decode(contentKey).valueOr:
        # TODO: as this should not fail, maybe it is better to raiseAssert ?
        return

      case contentKey.contentType
      of unused:
        raiseAssert "Should not be used and fail at decoding"
      of lightClientBootstrap:
        let bootstrap = decodeLightClientBootstrapForked(db.forkDigests, content).valueOr:
          return

        withForkyObject(bootstrap):
          when lcDataFork > LightClientDataFork.None:
            db.putBootstrap(contentId, content, forkyObject.header.beacon.slot)
      of lightClientUpdate:
        let updates = decodeSsz(content, ForkedLightClientUpdateBytesList).valueOr:
          return

        # Lot of assumptions here:
        # - that updates are continuous i.e. there is no period gaps
        # - that updates start from startPeriod of content key
        var period = contentKey.lightClientUpdateKey.startPeriod
        for update in updates.asSeq():
          # Only put the update if it is better, although in currently a new offer
          # should not be accepted as it is based on only the period.
          db.putUpdateIfBetter(SyncCommitteePeriod(period), update.asSeq())
          inc period
      of lightClientFinalityUpdate:
        db.beaconDbCache.finalityUpdateCache = Opt.some(
          LightClientFinalityUpdateCache(
            latestFinalityUpdateSlot:
              contentKey.lightClientFinalityUpdateKey.finalizedSlot,
            latestFinalityUpdate: content,
          )
        )
      of lightClientOptimisticUpdate:
        db.beaconDbCache.optimisticUpdateCache = Opt.some(
          LightClientOptimisticUpdateCache(
            latestOptimisticUpdateSlot:
              contentKey.lightClientOptimisticUpdateKey.optimisticSlot,
            latestOptimisticUpdate: content,
          )
        )
      of beacon_content.ContentType.historicalSummaries:
        db.putLatestHistoricalSummaries(content)

      return false # No data pruned
  )

proc createContainsHandler*(db: BeaconDb): DbContainsHandler =
  return (
    proc(contentKey: ContentKeyByteList, contentId: ContentId): bool =
      # TODO: Implement cheaper `contains` handlers
      db.getHandlerImpl(contentKey, contentId).isSome()
  )

proc createRadiusHandler*(db: BeaconDb): DbRadiusHandler =
  return (
    proc(): UInt256 {.raises: [], gcsafe.} =
      db.dataRadius
  )
