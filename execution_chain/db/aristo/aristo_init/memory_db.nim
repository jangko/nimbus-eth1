# nimbus-eth1
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed
# except according to those terms.

## In-memory backend for Aristo DB
## ===============================
##
## The iterators provided here are currently available only by direct
## backend access
## ::
##   import
##     aristo/aristo_init/aristo_memory
##
##   let rc = newAristoDbRef(BackendMemory)
##   if rc.isOk:
##     let be = rc.value.to(MemBackendRef)
##     for (n, key, vtx) in be.walkVtx:
##       ...
##
{.push raises: [].}

import
  std/[algorithm, sequtils, tables],
  results,
  ../aristo_constants,
  ../aristo_desc,
  ../aristo_desc/desc_backend,
  ../aristo_blobify,
  ./init_common

const
   extraTraceMessages = false # or true
     ## Enabled additional logging noise

type
  MemDbRef* = ref object
    ## Database
    sTab*: Table[RootedVertexID,seq[byte]] ## Structural vertex table making up a trie
    tUvi*: Opt[VertexID]                   ## Top used vertex ID
    lSst*: Opt[SavedState]                 ## Last saved state

  MemBackendRef* = ref object of TypedBackendRef
    ## Inheriting table so access can be extended for debugging purposes
    mdb: MemDbRef                         ## Database

  MemPutHdlRef = ref object of TypedPutHdlRef
    sTab: Table[RootedVertexID,seq[byte]]
    tUvi: Opt[VertexID]
    lSst: Opt[SavedState]

when extraTraceMessages:
  import chronicles

  logScope:
    topics = "aristo-backend"

# ------------------------------------------------------------------------------
# Private helpers
# ------------------------------------------------------------------------------

proc newSession(db: MemBackendRef): MemPutHdlRef =
  new result
  result.TypedPutHdlRef.beginSession db

proc getSession(hdl: PutHdlRef; db: MemBackendRef): MemPutHdlRef =
  hdl.TypedPutHdlRef.verifySession db
  hdl.MemPutHdlRef

proc endSession(hdl: PutHdlRef; db: MemBackendRef): MemPutHdlRef =
  hdl.TypedPutHdlRef.finishSession db
  hdl.MemPutHdlRef

# ------------------------------------------------------------------------------
# Private functions: interface
# ------------------------------------------------------------------------------

proc getVtxFn(db: MemBackendRef): GetVtxFn =
  result =
    proc(rvid: RootedVertexID, flags: set[GetVtxFlag]): Result[VertexRef,AristoError] =
      # Fetch serialised data record
      let data = db.mdb.sTab.getOrDefault(rvid, EmptyBlob)
      if 0 < data.len:
        let rc = data.deblobify(VertexRef)
        when extraTraceMessages:
          if rc.isErr:
            trace logTxt "getVtxFn() failed", error=rc.error
        return rc
      err(GetVtxNotFound)

proc getKeyFn(db: MemBackendRef): GetKeyFn =
  result =
    proc(rvid: RootedVertexID, flags: set[GetVtxFlag]): Result[(HashKey, VertexRef),AristoError] =
      let data = db.mdb.sTab.getOrDefault(rvid, EmptyBlob)
      if 0 < data.len:
        let key = data.deblobify(HashKey).valueOr:
          let vtx = data.deblobify(VertexRef).valueOr:
            return err(GetKeyNotFound)
          return ok((VOID_HASH_KEY, vtx))
        return ok((key, nil))
      err(GetKeyNotFound)

proc getTuvFn(db: MemBackendRef): GetTuvFn =
  result =
    proc(): Result[VertexID,AristoError]=
      db.mdb.tUvi or ok(VertexID(0))

proc getLstFn(db: MemBackendRef): GetLstFn =
  result =
    proc(): Result[SavedState,AristoError]=
      db.mdb.lSst or err(GetLstNotFound)

# -------------

proc putBegFn(db: MemBackendRef): PutBegFn =
  result =
    proc(): Result[PutHdlRef,AristoError] =
      ok db.newSession()


proc putVtxFn(db: MemBackendRef): PutVtxFn =
  result =
    proc(hdl: PutHdlRef; rvid: RootedVertexID; vtx: VertexRef, key: HashKey) =
      let hdl = hdl.getSession db
      if hdl.error.isNil:
        if vtx.isValid:
          hdl.sTab[rvid] = vtx.blobify(key)
        else:
          hdl.sTab[rvid] = EmptyBlob

proc putTuvFn(db: MemBackendRef): PutTuvFn =
  result =
    proc(hdl: PutHdlRef; vs: VertexID)  =
      let hdl = hdl.getSession db
      if hdl.error.isNil:
        hdl.tUvi = Opt.some(vs)

proc putLstFn(db: MemBackendRef): PutLstFn =
  result =
    proc(hdl: PutHdlRef; lst: SavedState) =
      let hdl = hdl.getSession db
      if hdl.error.isNil:
        hdl.lSst = Opt.some(lst)

proc putEndFn(db: MemBackendRef): PutEndFn =
  result =
    proc(hdl: PutHdlRef): Result[void,AristoError] =
      let hdl = hdl.endSession db
      if not hdl.error.isNil:
        when extraTraceMessages:
          case hdl.error.pfx:
          of VtxPfx: trace logTxt "putEndFn: vtx/key failed",
            pfx=hdl.error.pfx, vid=hdl.error.vid, error=hdl.error.code
          of AdmPfx: trace logTxt "putEndFn: admin failed",
            pfx=AdmPfx, aid=hdl.error.aid.uint64, error=hdl.error.code
          of Oops: trace logTxt "putEndFn: failed",
             pfx=hdl.error.pfx, error=hdl.error.code
        return err(hdl.error.code)

      for (vid,data) in hdl.sTab.pairs:
        if 0 < data.len:
          db.mdb.sTab[vid] = data
        else:
          db.mdb.sTab.del vid

      let tuv = hdl.tUvi.get(otherwise = VertexID(0))
      if tuv.isValid:
        db.mdb.tUvi = Opt.some(tuv)

      if hdl.lSst.isSome:
        db.mdb.lSst = hdl.lSst

      ok()

# -------------

proc closeFn(db: MemBackendRef): CloseFn =
  result =
    proc(ignore: bool) =
      discard

# ------------------------------------------------------------------------------
# Public functions
# ------------------------------------------------------------------------------

proc memoryBackend*(mdb = MemDbRef()): BackendRef =
  let db = MemBackendRef(
    beKind: BackendMemory,
    mdb:    mdb)

  db.getVtxFn = getVtxFn db
  db.getKeyFn = getKeyFn db
  db.getTuvFn = getTuvFn db
  db.getLstFn = getLstFn db

  db.putBegFn = putBegFn db
  db.putVtxFn = putVtxFn db
  db.putTuvFn = putTuvFn db
  db.putLstFn = putLstFn db
  db.putEndFn = putEndFn db

  db.closeFn = closeFn db
  db

proc dup*(db: MemBackendRef): MemBackendRef =
  ## Duplicate descriptor shell as needed for API debugging
  new result
  init_common.init(result[], db[])
  result.mdb = db.mdb

# ------------------------------------------------------------------------------
# Public iterators (needs direct backend access)
# ------------------------------------------------------------------------------

iterator walkVtx*(
    be: MemBackendRef;
    kinds = {Branch, Leaf};
      ): tuple[rvid: RootedVertexID, vtx: VertexRef] =
  ##  Iteration over the vertex sub-table.
  for n,rvid in be.mdb.sTab.keys.toSeq.mapIt(it).sorted:
    let data = be.mdb.sTab.getOrDefault(rvid, EmptyBlob)
    if 0 < data.len:
      let rc = data.deblobify VertexRef
      if rc.isErr:
        when extraTraceMessages:
          debug logTxt "walkVtxFn() skip", n, rvid, error=rc.error
      else:
        if rc.value.vType in kinds:
          yield (rvid, rc.value)

iterator walkKey*(
    be: MemBackendRef;
      ): tuple[rvid: RootedVertexID, key: HashKey] =
  ## Iteration over the Markle hash sub-table.
  for n,rvid in be.mdb.sTab.keys.toSeq.mapIt(it).sorted:
    let data = be.mdb.sTab.getOrDefault(rvid, EmptyBlob)
    if 0 < data.len:
      let rc = data.deblobify HashKey
      if rc.isNone:
        when extraTraceMessages:
          debug logTxt "walkKeyFn() skip", n, rvid
      else:
        yield (rvid, rc.value)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
