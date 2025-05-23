# Nimbus
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

import
  stint,
  chronicles,
  eth/common/eth_types_rlp,
  ./wd_base_spec,
  ../test_env,
  ../engine_client,
  ../types,
  ../../../../execution_chain/transaction

type
  BlockValueSpec* = ref object of WDBaseSpec

proc execute*(ws: BlockValueSpec, env: TestEnv): bool =
  WDBaseSpec(ws).skipBaseVerifications = true
  testCond WDBaseSpec(ws).execute(env)

  # Get the latest block and the transactions included
  let b = env.client.latestBlock()
  b.expectNoError()
  let blk = b.get

  var totalValue: UInt256
  testCond blk.txs.len > 0:
    error "No transactions included in latest block"

  for tx in blk.txs:
    let txHash = computeRlpHash(tx)
    let r = env.client.txReceipt(txHash)
    r.expectNoError()

    let
      rec = r.get
      txTip = tx.effectiveGasTip(blk.header.baseFeePerGas)

    totalValue += txTip.uint64.u256 * rec.gasUsed.u256

  doAssert(env.clMock.latestBlockValue.isSome)
  testCond totalValue == env.clMock.latestBlockValue.get:
    error "Unexpected block value returned on GetPayloadV2",
      expect=totalValue,
      get=env.clMock.latestBlockValue.get
  return true
