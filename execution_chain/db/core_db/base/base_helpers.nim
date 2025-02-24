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
  "../.."/[aristo, kvt],
  "."/[base_config, base_desc]

when CoreDbAutoValidateDescriptors:
  import
    ./base_validate

when CoreDbEnableProfiling:
  import
    ./api_tracking

# ------------------------------------------------------------------------------
# Public constructor helper
# ------------------------------------------------------------------------------

proc bless*(db: CoreDbRef): CoreDbRef =
  ## Verify descriptor
  when CoreDbAutoValidateDescriptors:
    db.validate
  when CoreDbEnableProfiling:
    db.profTab = CoreDbProfListRef.init()
  db

proc bless*(db: CoreDbRef; ctx: CoreDbCtxRef): CoreDbCtxRef =
  ctx.parent = db
  when CoreDbAutoValidateDescriptors:
    ctx.validate
  ctx

proc bless*(ctx: CoreDbCtxRef; dsc: CoreDbTxRef): auto =
  dsc.ctx = ctx
  when CoreDbAutoValidateDescriptors:
    dsc.validate
  dsc

# ------------------------------------------------------------------------------
# Public KVT helpers
# ------------------------------------------------------------------------------

template kvt*(dsc: CoreDbKvtRef): KvtDbRef =
  CoreDbCtxRef(dsc).kvt

template kvt*(tx: CoreDbTxRef): KvtDbRef =
  tx.ctx.kvt

template ctx*(kvt: CoreDbKvtRef): CoreDbCtxRef =
  CoreDbCtxRef(kvt)

# ---------------

template call*(api: KvtApiRef; fn: untyped; args: varargs[untyped]): untyped =
  when CoreDbEnableApiJumpTable:
    api.fn(args)
  else:
    fn(args)

template call*(kvt: CoreDbKvtRef; fn: untyped; args: varargs[untyped]): untyped =
  CoreDbCtxRef(kvt).parent.kvtApi.call(fn, args)

# ---------------

func toError*(e: KvtError; s: string; error = Unspecified): CoreDbError =
  CoreDbError(
    error:    error,
    ctx:      s,
    isAristo: false,
    kErr:     e)

# ------------------------------------------------------------------------------
# Public Aristo helpers
# ------------------------------------------------------------------------------

template mpt*(dsc: CoreDbAccRef): AristoDbRef =
  CoreDbCtxRef(dsc).mpt

template mpt*(tx: CoreDbTxRef): AristoDbRef =
  tx.ctx.mpt

template ctx*(acc: CoreDbAccRef): CoreDbCtxRef =
  CoreDbCtxRef(acc)

# ---------------

template call*(api: AristoApiRef; fn: untyped; args: varargs[untyped]): untyped =
  when CoreDbEnableApiJumpTable:
    api.fn(args)
  else:
    fn(args)

template call*(
    acc: CoreDbAccRef;
    fn: untyped;
    args: varargs[untyped];
      ): untyped =
  CoreDbCtxRef(acc).parent.ariApi.call(fn, args)

# ---------------

func toError*(e: AristoError; s: string; error = Unspecified): CoreDbError =
  CoreDbError(
    error:    error,
    ctx:      s,
    isAristo: true,
    aErr:     e)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
