# Nimbus
# Copyright (c) 2018-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

{.push raises: [].}

import
  std/sequtils,
  ".."/[db/ledger, constants],
  "."/[code_stream, memory, stack, state],
  "."/[types],
  ./interpreter/[gas_meter, gas_costs, op_codes],
  ./evm_errors,
  ./code_bytes,
  ../common/[evmforks],
  ../utils/[utils, mergeutils],
  ../common/common,
  eth/common/eth_types_rlp,
  chronicles, chronos

export
  common

logScope:
  topics = "vm computation"

# ------------------------------------------------------------------------------
# Public functions
# ------------------------------------------------------------------------------

template getCoinbase*(c: Computation): Address =
  c.vmState.coinbase

template getTimestamp*(c: Computation): uint64 =
  c.vmState.blockCtx.timestamp.uint64

template getBlockNumber*(c: Computation): UInt256 =
  c.vmState.blockNumber.u256

template getDifficulty*(c: Computation): DifficultyInt =
  c.vmState.difficultyOrPrevRandao

template getGasLimit*(c: Computation): GasInt =
  c.vmState.blockCtx.gasLimit

template getBaseFee*(c: Computation): UInt256 =
  c.vmState.blockCtx.baseFeePerGas.get(0.u256)

template getChainId*(c: Computation): UInt256 =
  c.vmState.com.chainId

template getOrigin*(c: Computation): Address =
  c.vmState.txCtx.origin

template getGasPrice*(c: Computation): GasInt =
  c.vmState.txCtx.gasPrice

template getVersionedHash*(c: Computation, index: int): VersionedHash =
  c.vmState.txCtx.versionedHashes[index]

template getVersionedHashesLen*(c: Computation): int =
  c.vmState.txCtx.versionedHashes.len

template getBlobBaseFee*(c: Computation): UInt256 =
  c.vmState.txCtx.blobBaseFee

proc getBlockHash*(c: Computation, number: BlockNumber): Hash32 =
  let
    blockNumber = c.vmState.blockNumber
    ancestorDepth = blockNumber - number - 1
  if ancestorDepth >= constants.MAX_PREV_HEADER_DEPTH:
    return default(Hash32)
  if number >= blockNumber:
    return default(Hash32)
  c.vmState.getAncestorHash(number)

template accountExists*(c: Computation, address: Address): bool =
  if c.fork >= FkSpurious:
    not c.vmState.readOnlyLedger.isDeadAccount(address)
  else:
    c.vmState.readOnlyLedger.accountExists(address)

template getStorage*(c: Computation, slot: UInt256): UInt256 =
  c.vmState.readOnlyLedger.getStorage(c.msg.contractAddress, slot)

template getBalance*(c: Computation, address: Address): UInt256 =
  c.vmState.readOnlyLedger.getBalance(address)

template getCodeSize*(c: Computation, address: Address): uint =
  uint(c.vmState.readOnlyLedger.getCodeSize(address))

template getCodeHash*(c: Computation, address: Address): Hash32 =
  let
    db = c.vmState.readOnlyLedger
  if not db.accountExists(address) or db.isEmptyAccount(address):
    default(Hash32)
  else:
    db.getCodeHash(address)

template selfDestruct*(c: Computation, address: Address) =
  c.execSelfDestruct(address)

template getCode*(c: Computation, address: Address): CodeBytesRef =
  c.vmState.readOnlyLedger.getCode(address)

template setTransientStorage*(c: Computation, slot, val: UInt256) =
  c.transientStorage.setStorage(c.msg.contractAddress, slot, val)

func getTransientStorage*(c: Computation, slot: UInt256): UInt256 =
  var cpt = c
  while cpt != nil:
    let (ok, res) = cpt.transientStorage.getStorage(c.msg.contractAddress, slot)
    if ok:
      return res
    cpt = cpt.parent

func newComputation*(vmState: BaseVMState,
                     keepStack: bool,
                     message: Message,
                     code = CodeBytesRef(nil)): Computation =
  new result
  result.vmState = vmState
  result.msg = message
  result.gasMeter.init(message.gas)
  result.keepStack = keepStack

  if not code.isNil:
    result.code = CodeStream.init(code)
    result.memory = EvmMemory.init()
    result.stack = EvmStack.init()

template gasCosts*(c: Computation): untyped =
  c.vmState.gasCosts

template fork*(c: Computation): untyped =
  c.vmState.fork

template isSuccess*(c: Computation): bool =
  c.error.isNil

template isError*(c: Computation): bool =
  not c.isSuccess

func shouldBurnGas*(c: Computation): bool =
  c.isError and c.error.burnsGas

proc snapshot*(c: Computation) =
  c.savePoint = c.vmState.ledger.beginSavepoint()

proc commit*(c: Computation) =
  c.vmState.ledger.commit(c.savePoint)

proc dispose*(c: Computation) =
  c.vmState.ledger.safeDispose(c.savePoint)
  if c.stack != nil:
    if c.keepStack:
      c.finalStack = toSeq(c.stack.items())

    c.stack.dispose()
    c.stack = nil
  c.savePoint = nil

proc rollback*(c: Computation) =
  c.vmState.ledger.rollback(c.savePoint)

func setError*(c: Computation, msg: sink string, burnsGas = false) =
  c.error = Error(status: StatusCode.Failure, info: move(msg), burnsGas: burnsGas)

func setError*(c: Computation, code: StatusCode, burnsGas = false) =
  c.error = Error(status: code, info: $code, burnsGas: burnsGas)

func setError*(
    c: Computation, code: StatusCode, msg: sink string, burnsGas = false) =
  c.error = Error(status: code, info: move(msg), burnsGas: burnsGas)

func errorOpt*(c: Computation): Opt[string] =
  if c.isSuccess:
    return Opt.none(string)
  if c.error.status == StatusCode.Revert:
    return Opt.none(string)
  Opt.some(c.error.info)

proc writeContract*(c: Computation) =
  template withExtra(tracer: untyped, args: varargs[untyped]) =
    tracer args, newContract=($c.msg.contractAddress),
      blockNumber=c.vmState.blockNumber,
      parentHash=($c.vmState.parent.computeBlockHash)

  # In each check below, they are guarded by `len > 0`.  This includes writing
  # out the code, because the account already has zero-length code to handle
  # nested calls (this is specified).  May as well simplify other branches.
  let (len, fork) = (c.output.len, c.fork)
  if len == 0:
    return

  # EIP-3541 constraint (https://eips.ethereum.org/EIPS/eip-3541).
  if fork >= FkLondon and c.output[0] == 0xEF.byte:
    withExtra trace, "New contract code starts with 0xEF byte, not allowed by EIP-3541"
    c.setError(StatusCode.ContractValidationFailure, true)
    return

  # EIP-170 constraint (https://eips.ethereum.org/EIPS/eip-3541).
  if fork >= FkSpurious and len > EIP170_MAX_CODE_SIZE:
    withExtra trace, "New contract code exceeds EIP-170 limit",
      codeSize=len, maxSize=EIP170_MAX_CODE_SIZE
    c.setError(StatusCode.OutOfGas, true)
    return

  # Charge gas and write the code even if the code address is self-destructed.
  # Non-empty code in a newly created, self-destructed account is possible if
  # the init code calls `DELEGATECALL` or `CALLCODE` to other code which uses
  # `SELFDESTRUCT`.  This shows on Mainnet blocks 6001128..6001204, where the
  # gas difference matters.  The new code can be called later in the
  # transaction too, before self-destruction wipes the account at the end.

  let
    gasParams = GasParamsCr(memLength: len)
    codeCost = c.gasCosts[Create].cr_handler(0.u256, gasParams)

  if codeCost <= c.gasMeter.gasRemaining:
    c.gasMeter.consumeGas(codeCost,
      reason = "Write new contract code").
        expect("enough gas since we checked against gasRemaining")
    c.vmState.mutateLedger:
      db.setCode(c.msg.contractAddress, c.output)
    withExtra trace, "Writing new contract code"
    return

  if fork >= FkHomestead:
    # EIP-2 (https://eips.ethereum.org/EIPS/eip-2).
    c.setError(StatusCode.OutOfGas, true)
  else:
    # Before EIP-2, when out of gas for code storage, the account ends up with
    # zero-length code and no error.  No gas is charged.  Code cited in EIP-2:
    # https://github.com/ethereum/pyethereum/blob/d117c8f3fd93/ethereum/processblock.py#L304
    # https://github.com/ethereum/go-ethereum/blob/401354976bb4/core/vm/instructions.go#L586
    # The account already has zero-length code to handle nested calls.
    withExtra trace, "New contract given empty code by pre-Homestead rules"

template chainTo*(c: Computation,
                  toChild: typeof(c.child),
                  after: untyped) =

  c.child = toChild
  c.continuation = proc(): EvmResultVoid {.gcsafe, raises: [].} =
    c.continuation = nil
    after

proc execSelfDestruct*(c: Computation, beneficiary: Address) =
  c.vmState.mutateLedger:
    let localBalance = c.getBalance(c.msg.contractAddress)

    # Register the account to be deleted
    if c.fork >= FkCancun:
      # Zeroing contract balance except beneficiary
      # is the same address
      db.subBalance(c.msg.contractAddress, localBalance)

      # Transfer to beneficiary
      db.addBalance(beneficiary, localBalance)

      db.selfDestruct6780(c.msg.contractAddress)
    else:
      # Transfer to beneficiary
      db.addBalance(beneficiary, localBalance)
      db.selfDestruct(c.msg.contractAddress)

    trace "SELFDESTRUCT",
      contractAddress = c.msg.contractAddress.toHex,
      localBalance = localBalance.toString,
      beneficiary = beneficiary.toHex

# Using `proc` as `addLogEntry()` might be `proc` in logging mode
proc addLogEntry*(c: Computation, log: Log) =
  c.logEntries.add log

func merge*(c, child: Computation) =
  c.logEntries.mergeAndReset(child.logEntries)
  c.transientStorage.mergeAndReset(child.transientStorage)
  c.gasMeter.refundGas(child.gasMeter.gasRefunded)

# some gasRefunded operations still relying
# on negative number
func getGasRefund*(c: Computation): GasInt =
  # EIP-2183 guarantee that sum of all child gasRefund
  # should never go below zero
  doAssert(c.msg.depth == 0 and c.gasMeter.gasRefunded >= 0)
  var gasRefunded = c.vmState.gasRefunded
  if c.isSuccess:
    gasRefunded += c.gasMeter.gasRefunded

  GasInt gasRefunded

func addRefund*(c: Computation, amount: int64) =
  c.vmState.gasRefunded += amount

# Using `proc` as `selfDestructLen()` might be `proc` in logging mode
proc refundSelfDestruct*(c: Computation) =
  let cost = gasFees[c.fork][RefundSelfDestruct]
  let num  = c.vmState.ledger.selfDestructLen
  c.gasMeter.refundGas(cost * num)

func tracingEnabled*(c: Computation): bool =
  c.vmState.tracingEnabled

func traceOpCodeStarted*(c: Computation, op: Op): int =
  c.vmState.captureOpStart(
    c,
    c.code.pc - 1,
    op,
    c.gasMeter.gasRemaining,
    c.msg.depth + 1)

func traceOpCodeEnded*(c: Computation, op: Op, opIndex: int) =
  c.vmState.captureOpEnd(
    c,
    c.code.pc - 1,
    op,
    c.gasMeter.gasRemaining,
    c.gasMeter.gasRefunded,
    c.returnData,
    c.msg.depth + 1,
    opIndex)

func traceError*(c: Computation) =
  c.vmState.captureFault(
    c,
    c.code.pc - 1,
    c.instr,
    c.gasMeter.gasRemaining,
    c.gasMeter.gasRefunded,
    c.returnData,
    c.msg.depth + 1,
    c.errorOpt)

func prepareTracer*(c: Computation) =
  c.vmState.capturePrepare(c, c.msg.depth)

template opcodeGasCost*(
    c: Computation, op: Op, gasCost: static GasInt, tracingEnabled: static bool,
    reason: static string): EvmResultVoid =
  # Special case of the opcodeGasCost function used for fixed-gas opcodes - since
  # the parameters are known at compile time, we inline and specialize it
  when tracingEnabled:
    c.vmState.captureGasCost(
      c,
      op,
      gasCost,
      c.gasMeter.gasRemaining,
      c.msg.depth + 1)
  c.gasMeter.consumeGas(gasCost, reason)

template opcodeGasCost*(
    c: Computation, op: Op, gasCost: GasInt, reason: static string): EvmResultVoid =
  let cost = gasCost
  if c.vmState.tracingEnabled:
    c.vmState.captureGasCost(
      c,
      op,
      cost,
      c.gasMeter.gasRemaining,
      c.msg.depth + 1)
  c.gasMeter.consumeGas(cost, reason)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
