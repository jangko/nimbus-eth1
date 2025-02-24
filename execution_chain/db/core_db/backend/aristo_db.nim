# Nimbus
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

{.push raises: [].}

import
  ../../aristo as use_ari,
  ../../aristo/[aristo_init/memory_only, aristo_walk/memory_only],
  ../../kvt as use_kvt,
  ../../kvt/[kvt_init/memory_only, kvt_walk/memory_only],
  ../base/[base_config, base_desc, base_helpers]

export base_desc

# ------------------------------------------------------------------------------
# Public constructors
# ------------------------------------------------------------------------------

proc create*(dbType: CoreDbType; kvt: KvtDbRef; mpt: AristoDbRef): CoreDbRef =
  ## Constructor helper
  var db = CoreDbRef(dbType: dbType)
  db.defCtx = db.bless CoreDbCtxRef(mpt: mpt, kvt: kvt)

  when CoreDbEnableApiJumpTable:
    db.kvtApi = KvtApiRef.init()
    db.ariApi = AristoApiRef.init()

  when CoreDbEnableProfiling:
    block:
      let profApi = KvtApiProfRef.init(db.kvtApi, kvt.backend)
      db.kvtApi = profApi
      kvt.backend = profApi.be
    block:
      let profApi = AristoApiProfRef.init(db.ariApi, mpt.backend)
      db.ariApi = profApi
      mpt.backend = profApi.be
  bless db

proc newMemoryCoreDbRef*(): CoreDbRef =
  AristoDbMemory.create(
    KvtDbRef.init(use_kvt.MemBackendRef),
    AristoDbRef.init(use_ari.MemBackendRef))

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
