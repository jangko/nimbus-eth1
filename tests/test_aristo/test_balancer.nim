# Nimbus
# Copyright (c) 2023-2024 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or
# distributed except according to those terms.

## Aristo (aka Patricia) DB records distributed backend access test.
##

import
  eth/common,
  results,
  unittest2,
  ../../nimbus/db/opts,
  ../../nimbus/db/core_db/backend/aristo_rocksdb,
  ../../nimbus/db/aristo/[
    aristo_check,
    aristo_debug,
    aristo_desc,
    aristo_get,
    aristo_persistent,
    aristo_tx],
  ../replay/xcheck,
  ./test_helpers

type
  LeafQuartet =
    array[0..3, seq[LeafTiePayload]]

  DbTriplet =
    array[0..2, AristoDbRef]

const
  testRootVid = VertexID(2)
    ## Need to reconfigure for the test, root ID 1 cannot be deleted as a trie

# ------------------------------------------------------------------------------
# Private debugging helpers
# ------------------------------------------------------------------------------

proc dump(pfx: string; dx: varargs[AristoDbRef]): string =
  if 0 < dx.len:
    result = "\n   "
  var
    pfx = pfx
    qfx = ""
  if pfx.len == 0:
    (pfx,qfx) = ("[","]")
  elif 1 < dx.len:
    pfx = pfx & "#"
  for n in 0 ..< dx.len:
    let n1 = n + 1
    result &= pfx
    if 1 < dx.len:
      result &= $n1
    result &= qfx & "\n    " & dx[n].pp(backendOk=true) & "\n"
    if n1 < dx.len:
      result &= "   ==========\n   "

proc dump(dx: varargs[AristoDbRef]): string {.used.} =
  "".dump dx

# ------------------------------------------------------------------------------
# Private helpers
# ------------------------------------------------------------------------------

iterator quadripartite(td: openArray[ProofTrieData]): LeafQuartet =
  ## ...
  var collect: seq[seq[LeafTiePayload]]

  for w in td:
    let lst = w.kvpLst.mapRootVid testRootVid

    if lst.len < 8:
      if 2 < collect.len:
        yield [collect[0], collect[1], collect[2], lst]
        collect.setLen(0)
      else:
        collect.add lst
    else:
      if collect.len == 0:
        let a = lst.len div 4
        yield [lst[0 ..< a], lst[a ..< 2*a], lst[2*a ..< 3*a], lst[3*a .. ^1]]
      else:
        if collect.len == 1:
          let a = lst.len div 3
          yield [collect[0], lst[0 ..< a], lst[a ..< 2*a], lst[a .. ^1]]
        elif collect.len == 2:
          let a = lst.len div 2
          yield [collect[0], collect[1], lst[0 ..< a], lst[a .. ^1]]
        else:
          yield [collect[0], collect[1], collect[2], lst]
        collect.setLen(0)

proc dbTriplet(w: LeafQuartet; rdbPath: string): Result[AristoDbRef,AristoError] =
  let db = block:
    if 0 < rdbPath.len:
      let (dbOpts, cfOpts) = DbOptions.init().toRocksDb()
      let rc = AristoDbRef.init(RdbBackendRef, rdbPath, DbOptions.init(), dbOpts, cfOpts, [])
      xCheckRc rc.error == 0:
        result = err(rc.error)
      rc.value()[0]
    else:
      AristoDbRef.init MemBackendRef

  # Set failed `xCheck()` error result
  result = err(AristoError 1)

  # Fill backend
  block:
    let report = db.mergeList w[0]
    if report.error != 0:
      db.finish(eradicate=true)
      xCheck report.error == 0
    let rc = db.persist()
    xCheckRc rc.error == 0:
      result = err(rc.error)

  let dx = db

# ----------------------

proc cleanUp(dx: var AristoDbRef) =
  if not dx.isNil:
    dx.finish(eradicate=true)
    dx.reset

# ----------------------

proc isDbEq(a, b: LayerRef; db: AristoDbRef; noisy = true): bool =
  ## Verify that argument filter `a` has the same effect on the
  ## physical/unfiltered backend of `db` as argument filter `b`.
  if a.isNil:
    return b.isNil
  if b.isNil:
    return false
  if unsafeAddr(a[]) != unsafeAddr(b[]):
    if a.kMap.getOrVoid((testRootVid, testRootVid)) !=
       b.kMap.getOrVoid((testRootVid, testRootVid)) or
       a.vTop != b.vTop:
      return false

    # Void entries may differ unless on physical backend
    var (aTab, bTab) = (a.sTab, b.sTab)
    if aTab.len < bTab.len:
      aTab.swap bTab
    for (vid,aVtx) in aTab.pairs:
      let bVtx = bTab.getOrVoid vid
      bTab.del vid

      if aVtx != bVtx:
        if aVtx.isValid and bVtx.isValid:
          return false
        # The valid one must match the backend data
        let rc = db.getVtxUbe vid
        if rc.isErr:
          return false
        let vtx = if aVtx.isValid: aVtx else: bVtx
        if vtx != rc.value:
          return false

      elif not vid.isValid and not bTab.hasKey vid:
        let rc = db.getVtxUbe vid
        if rc.isOk:
          return false # Exists on backend but missing on `bTab[]`
        elif rc.error != GetKeyNotFound:
          return false # general error

    if 0 < bTab.len:
      noisy.say "***", "not dbEq:", "bTabLen=", bTab.len
      return false

    # Similar for `kMap[]`
    var (aMap, bMap) = (a.kMap, b.kMap)
    if aMap.len < bMap.len:
      aMap.swap bMap
    for (vid,aKey) in aMap.pairs:
      let bKey = bMap.getOrVoid vid
      bMap.del vid

      if aKey != bKey:
        if aKey.isValid and bKey.isValid:
          return false
        # The valid one must match the backend data
        let rc = db.getKeyUbe(vid, {})
        if rc.isErr:
          return false
        let key = if aKey.isValid: aKey else: bKey
        if key != rc.value[0]:
          return false

      elif not vid.isValid and not bMap.hasKey vid:
        let rc = db.getKeyUbe(vid, {})
        if rc.isOk:
          return false # Exists on backend but missing on `bMap[]`
        elif rc.error != GetKeyNotFound:
          return false # general error

    if 0 < bMap.len:
      noisy.say "***", "not dbEq:", " bMapLen=", bMap.len
      return false

  true

# ----------------------

proc checkBeOk(
    dx: AristoDbRef;
    forceCache = false;
    noisy = true;
      ): bool =
  ## ..
  let rc = dx.checkBE()
  xCheckRc rc.error == (0,0):
    noisy.say "***", "db checkBE failed"
  true

# ------------------------------------------------------------------------------
# Public test function
# ------------------------------------------------------------------------------

proc testBalancer*(
    noisy: bool;
    list: openArray[ProofTrieData];
    rdbPath: string;                          # Rocks DB storage directory
       ): bool =
  var n = 0
  for w in list.quadripartite:
    n.inc

    # Resulting clause (11) filters from `aristo/README.md` example
    # which will be used in the second part of the tests
    var
      c11Filter1 = LayerRef(nil)
      c11Filter3 = LayerRef(nil)

    # Work through clauses (8)..(11) from `aristo/README.md` example
    block:

      # Clause (8) from `aristo/README.md` example
      var
        dx = block:
          let rc = dbTriplet(w, rdbPath)
          xCheckRc rc.error == 0
          rc.value
        db1 = dx
      defer:
        dx.cleanUp()

      when false: # or true:
        noisy.say "*** testDistributedAccess (1)", "n=", n # , dx.dump

      # Clause (9) from `aristo/README.md` example
      block:
        let rc = db1.persist()
        xCheckRc rc.error == 0
      xCheck db1.balancer == LayerRef(nil)

      # Check/verify backends
      block:
        let ok = dx.checkBeOk(noisy=noisy)
        xCheck ok:
          noisy.say "*** testDistributedAccess (4)", "n=", n

      # Capture filters from clause (11)
      c11Filter1 = db1.balancer

      # Clean up
      dx.cleanUp()

    # ----------

    # Work through clauses (12)..(15) from `aristo/README.md` example
    block:
      var
        dy = block:
          let rc = dbTriplet(w, rdbPath)
          xCheckRc rc.error == 0
          rc.value
        db1 = dy
      defer:
        dy.cleanUp()

      # Clause (14) from `aristo/README.md` check
      let c11Fil1_eq_db1RoFilter = c11Filter1.isDbEq(db1.balancer, db1, noisy)
      xCheck c11Fil1_eq_db1RoFilter:
        noisy.say "*** testDistributedAccess (7)", "n=", n,
          "db1".dump(db1),
          ""

      # Check/verify backends
      block:
        let ok = dy.checkBeOk(noisy=noisy)
        xCheck ok

      when false: # or true:
        noisy.say "*** testDistributedAccess (9)", "n=", n # , dy.dump

  true

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
