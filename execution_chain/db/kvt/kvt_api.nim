# nimbus-eth1
# Copyright (c) 2024-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed
# except according to those terms.

## Stackable API for `Kvt`
## =======================

import
  std/times,
  results,
  ../aristo/aristo_profile,
  ./kvt_desc/desc_backend,
  ./kvt_init/memory_db,
  ./kvt_init/memory_only,
  "."/[kvt_desc, kvt_persist, kvt_tx_frame, kvt_utils]

const
  AutoValidateApiHooks = defined(release).not
    ## No validatinon needed for production suite.

  KvtPersistentBackendOk = AutoValidateApiHooks # and false
    ## Set true for persistent backend profiling (which needs an extra
    ## link library.)

when KvtPersistentBackendOk:
  import ./kvt_init/rocks_db

# Annotation helper(s)
{.pragma: noRaise, gcsafe, raises: [].}

type
  KvtDbProfListRef* = AristoDbProfListRef
    ## Borrowed from `aristo_profile`

  KvtDbProfData* = AristoDbProfData
    ## Borrowed from `aristo_profile`

  KvtApiDelFn* = proc(db: KvtTxRef,
    key: openArray[byte]): Result[void,KvtError] {.noRaise.}
  KvtApiFinishFn* = proc(db: KvtDbRef, eradicate = false) {.noRaise.}
  KvtApiForgetFn* = proc(db: KvtDbRef): Result[void,KvtError] {.noRaise.}
  KvtApiGetFn* = proc(db: KvtTxRef,
    key: openArray[byte]): Result[seq[byte],KvtError] {.noRaise.}
  KvtApiLenFn* = proc(db: KvtTxRef,
    key: openArray[byte]): Result[int,KvtError] {.noRaise.}
  KvtApiHasKeyRcFn* = proc(db: KvtTxRef,
    key: openArray[byte]): Result[bool,KvtError] {.noRaise.}
  KvtApiPutFn* = proc(db: KvtTxRef,
    key, data: openArray[byte]): Result[void,KvtError] {.noRaise.}
  KvtApiDisposeFn* = proc(tx: KvtTxRef) {.noRaise.}
  KvtApiPersistFn* = proc(db: KvtDbRef, batch: PutHdlRef, txFrame: KvtTxRef) {.noRaise.}
  KvtApiToKvtDbRefFn* = proc(tx: KvtTxRef): KvtDbRef {.noRaise.}
  KvtApiTxFrameBeginFn* = proc(db: KvtDbRef, parent: KvtTxRef): KvtTxRef {.noRaise.}
  KvtApiBaseTxFrameFn* = proc(db: KvtDbRef): KvtTxRef {.noRaise.}

  KvtApiRef* = ref KvtApiObj
  KvtApiObj* = object of RootObj
    ## Useful set of `Kvt` fuctions that can be filtered, stacked etc. Note
    ## that this API is modelled after a subset of the `Aristo` API.
    del*: KvtApiDelFn
    finish*: KvtApiFinishFn
    get*: KvtApiGetFn
    len*: KvtApiLenFn
    hasKeyRc*: KvtApiHasKeyRcFn
    put*: KvtApiPutFn
    dispose*: KvtApiDisposeFn
    persist*: KvtApiPersistFn
    txFrameBegin*: KvtApiTxFrameBeginFn
    baseTxFrame*: KvtApiBaseTxFrameFn


  KvtApiProfNames* = enum
    ## index/name mapping for profile slots
    KvtApiProfTotal          = "total"

    KvtApiProfDelFn          = "del"
    KvtApiProfFinishFn       = "finish"
    KvtApiProfGetFn          = "get"
    KvtApiProfLenFn          = "len"
    KvtApiProfHasKeyRcFn     = "hasKeyRc"
    KvtApiProfPutFn          = "put"
    KvtApiProfDisposeFn     = "dispose"
    KvtApiProfPersistFn      = "persist"
    KvtApiProfTxFrameBeginFn      = "txFrameBegin"
    KvtApiProfBaseTxFrameFn      = "baseTxFrame"

    KvtApiProfBeGetKvpFn     = "be/getKvp"
    KvtApiProfBeLenKvpFn     = "be/lenKvp"
    KvtApiProfBePutKvpFn     = "be/putKvp"
    KvtApiProfBePutEndFn     = "be/putEnd"

  KvtApiProfRef* = ref object of KvtApiRef
    ## Profiling API extension of `KvtApiObj`
    data*: KvtDbProfListRef
    be*: BackendRef

# ------------------------------------------------------------------------------
# Private helpers
# ------------------------------------------------------------------------------

when AutoValidateApiHooks:
  proc validate(api: KvtApiObj) =
    for _, field in api.fieldPairs:
      doAssert not field.isNil

  proc validate(prf: KvtApiProfRef) =
    prf.KvtApiRef[].validate
    doAssert not prf.data.isNil

proc dup(be: BackendRef): BackendRef =
  case be.kind:
  of BackendMemory:
    return MemBackendRef(be).dup

  of BackendRocksDB:
    when KvtPersistentBackendOk:
      return RdbBackendRef(be).dup

# ------------------------------------------------------------------------------
# Public API constuctors
# ------------------------------------------------------------------------------

func init*(api: var KvtApiObj) =
  when AutoValidateApiHooks:
    api.reset
  api.del = del
  api.finish = finish
  api.get = get
  api.len = len
  api.hasKeyRc = hasKeyRc
  api.put = put
  api.dispose = dispose
  api.persist = persist
  api.txFrameBegin = txFrameBegin
  api.baseTxFrame = baseTxFrame

  when AutoValidateApiHooks:
    api.validate

func init*(T: type KvtApiRef): T =
  result = new T
  result[].init()

func dup*(api: KvtApiRef): KvtApiRef =
  result = KvtApiRef()
  result[] = api[]
  when AutoValidateApiHooks:
    result[].validate
# ------------------------------------------------------------------------------
# Public profile API constuctor
# ------------------------------------------------------------------------------

func init*(
    T: type KvtApiProfRef;
    api: KvtApiRef;
    be = BackendRef(nil);
      ): T =
  ## This constructor creates a profiling API descriptor to be derived from
  ## an initialised `api` argument descriptor. For profiling the DB backend,
  ## the field `.be` of the result descriptor must be assigned to the
  ## `.backend` field of the `KvtDbRef` descriptor.
  ##
  ## The argument desctiptors `api` and `be` will not be modified and can be
  ## used to restore the previous set up.
  ##
  let
    data = KvtDbProfListRef(
      list: newSeq[KvtDbProfData](1 + high(KvtApiProfNames).ord))
    profApi = T(data: data)

  template profileRunner(n: KvtApiProfNames, code: untyped): untyped =
    let start = getTime()
    code
    data.update(n.ord, getTime() - start)

  profApi.del =
    proc(a: KvtDbRef; b: openArray[byte]): auto =
      KvtApiProfDelFn.profileRunner:
        result = api.del(a, b)

  profApi.finish =
    proc(a: KvtDbRef; b = false) =
      KvtApiProfFinishFn.profileRunner:
        api.finish(a, b)

  profApi.get =
    proc(a: KvtDbRef, b: openArray[byte]): auto =
      KvtApiProfGetFn.profileRunner:
        result = api.get(a, b)

  profApi.len =
    proc(a: KvtDbRef, b: openArray[byte]): auto =
      KvtApiProfLenFn.profileRunner:
        result = api.len(a, b)

  profApi.hasKeyRc =
    proc(a: KvtDbRef, b: openArray[byte]): auto =
      KvtApiProfHasKeyRcFn.profileRunner:
        result = api.hasKeyRc(a, b)

  profApi.put =
    proc(a: KvtDbRef; b, c: openArray[byte]): auto =
      KvtApiProfPutFn.profileRunner:
        result = api.put(a, b, c)

  profApi.dispose =
    proc(a: KvtTxRef): auto =
      KvtApiProfDisposeFn.profileRunner:
        result = api.dispose(a)

  profApi.persist =
    proc(a: KvtDbRef): auto =
      KvtApiProfPersistFn.profileRunner:
        result = api.persist(a)

  profApi.txFrameBegin =
    proc(a: KvtDbRef) =
      KvtApiProfTxFrameBeginFn.profileRunner:
        api.txFrameBegin(a)

  let beDup = be.dup()
  if beDup.isNil:
    profApi.be = be

  else:
    beDup.getKvpFn =
      proc(a: openArray[byte]): auto =
        KvtApiProfBeGetKvpFn.profileRunner:
          result = be.getKvpFn(a)
    data.list[KvtApiProfBeGetKvpFn.ord].masked = true

    beDup.lenKvpFn =
      proc(a: openArray[byte]): auto =
        KvtApiProfBeLenKvpFn.profileRunner:
          result = be.lenKvpFn(a)
    data.list[KvtApiProfBeLenKvpFn.ord].masked = true

    beDup.putKvpFn =
      proc(a: PutHdlRef; b, c: openArray[byte]) =
        KvtApiProfBePutKvpFn.profileRunner:
          be.putKvpFn(a, b, c)
    data.list[KvtApiProfBePutKvpFn.ord].masked = true

    beDup.putEndFn =
      proc(a: PutHdlRef): auto =
        KvtApiProfBePutEndFn.profileRunner:
          result = be.putEndFn(a)
    data.list[KvtApiProfBePutEndFn.ord].masked = true

    profApi.be = beDup

  when AutoValidateApiHooks:
    profApi.validate

  profApi

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
