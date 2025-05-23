# Nimbus
# Copyright (c) 2020-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

import
  std/[json, strutils, os],
  eth/common/transaction_utils,
  eth/common/blocks,
  eth/common/eth_types_rlp,
  httputils,
  nimcrypto/utils,
  stint,
  stew/byteutils

from stew/objects import checkedEnumAssign

template stripLeadingZeros(value: string): string =
  var cidx = 0
  # ignore the last character so we retain '0' on zero value
  while cidx < value.len - 1 and value[cidx] == '0':
    cidx.inc
  value[cidx .. ^1]

func encodeQuantity(value: SomeUnsignedInt): string =
  var hValue = value.toHex.stripLeadingZeros
  result = "0x" & hValue.toLowerAscii

func hexToInt*(s: string, T: typedesc[SomeInteger]): T =
  var i = 0
  if s[i] == '0' and (s[i + 1] in {'x', 'X'}):
    inc(i, 2)
  if s.len - i > sizeof(T) * 2:
    raise newException(ValueError, "input hex too big for destination int")
  while i < s.len:
    result = result shl 4 or readHexChar(s[i]).T
    inc(i)

proc to0xHex*(x: int64 | uint64 | byte | int): string =
  toLowerAscii(encodeQuantity(x.uint64))

proc to0xHex*(x: UInt256): string =
  "0x" & stint.toHex(x)

proc to0xHex*(x: string): string =
  "0x" & toLowerAscii(x)

type SomeData* = Address | Bloom | Bytes8

proc fromJson*(n: JsonNode, name: string, x: var SomeData) =
  let node = n[name]
  if node.kind == JString:
    hexToByteArray(node.getStr(), x.data)
    doAssert(x.to0xHex == toLowerAscii(node.getStr()), name)
  else:
    hexToByteArray(node["value"].getStr(), x.data)
    doAssert(x.to0xHex == toLowerAscii(node["value"].getStr()), name)

proc fromJson*(n: JsonNode, name: string, x: var (Hash32 | Bytes32)) =
  let node = n[name]
  if node.kind == JString:
    hexToByteArray(node.getStr(), x.data)
    doAssert(x.to0xHex == toLowerAscii(node.getStr()), name)
  else:
    hexToByteArray(node["value"].getStr(), x.data)
    doAssert(x.to0xHex == toLowerAscii(node["value"].getStr()), name)

proc fromJson*(n: JsonNode, name: string, x: var seq[byte]) =
  x = hexToSeqByte(n[name].getStr())
  doAssert(x.to0xHex == toLowerAscii(n[name].getStr()), name)

proc fromJson*(n: JsonNode, name: string, x: var UInt256) =
  let node = n[name]
  if node.kind == JString:
    x = UInt256.fromHex(node.getStr())
    doAssert(x.to0xHex == toLowerAscii(node.getStr()), name)
  else:
    x = node.getInt().u256
    doAssert($x == $node.getInt, name)

proc fromJson*(n: JsonNode, name: string, x: var SomeInteger) =
  let node = n[name]
  if node.kind == JString:
    x = hexToInt(node.getStr(), type(x))
    doAssert(x.to0xHex == toLowerAscii(node.getStr()), name)
  else:
    type T = type x
    x = T(node.getInt)
    doAssert($x == $node.getInt, name)

proc fromJson*(n: JsonNode, name: string, x: var EthTime) =
  x = EthTime(hexToInt(n[name].getStr(), uint64))
  doAssert(x.uint64.to0xHex == toLowerAscii(n[name].getStr()), name)

proc fromJson*[T](n: JsonNode, name: string, x: var Opt[T]) =
  if name in n:
    var val: T
    n.fromJson(name, val)
    x = Opt.some(val)

proc fromJson*(n: JsonNode, name: string, x: var TxType) =
  let node = n[name]
  if node.kind == JInt:
    x = TxType(node.getInt)
  else:
    x = hexToInt(node.getStr(), int).TxType

proc fromJson*[T: Bytes32 | Hash32](n: JsonNode, name: string, x: var seq[T]) =
  let node = n[name]
  var h: T
  x = newSeqOfCap[T](node.len)
  for v in node:
    hexToByteArray(v.getStr(), h.data)
    x.add h

proc parseAuth(n: JsonNode): Authorization =
  n.fromJson("chainId", result.chainId)
  n.fromJson("address", result.address)
  n.fromJson("nonce", result.nonce)
  n.fromJson("v", result.v)
  n.fromJson("r", result.r)
  n.fromJson("s", result.s)

proc fromJson*(n: JsonNode, name: string, x: var seq[Authorization]) =
  let node = n[name]
  for v in node:
    x = newSeqOfCap[Authorization](node.len)
    x.add parseAuth(node)

proc parseBlockHeader*(n: JsonNode): Header =
  n.fromJson "parentHash", result.parentHash
  n.fromJson "sha3Uncles", result.ommersHash
  n.fromJson "miner", result.coinbase
  n.fromJson "stateRoot", result.stateRoot
  n.fromJson "transactionsRoot", result.txRoot
  n.fromJson "receiptsRoot", result.receiptsRoot
  n.fromJson "logsBloom", result.logsBloom
  n.fromJson "difficulty", result.difficulty
  n.fromJson "number", result.number
  n.fromJson "gasLimit", result.gasLimit
  n.fromJson "gasUsed", result.gasUsed
  n.fromJson "timestamp", result.timestamp
  n.fromJson "extraData", result.extraData
  n.fromJson "mixHash", result.mixHash
  n.fromJson "nonce", result.nonce
  n.fromJson "baseFeePerGas", result.baseFeePerGas
  n.fromJson "withdrawalsRoot", result.withdrawalsRoot
  n.fromJson "blobGasUsed", result.blobGasUsed
  n.fromJson "excessBlobGas", result.excessBlobGas
  n.fromJson "parentBeaconBlockRoot", result.parentBeaconBlockRoot

  if result.baseFeePerGas.get(0.u256) == 0.u256:
    # probably geth bug
    result.baseFeePerGas = Opt.none(UInt256)

proc parseAccessPair(n: JsonNode): AccessPair =
  n.fromJson "address", result.address
  let keys = n["storageKeys"]
  for kn in keys:
    result.storageKeys.add Bytes32.fromHex(kn.getStr())

proc parseTransaction*(n: JsonNode): Transaction =
  var tx = Transaction(txType: TxLegacy)
  n.fromJson "nonce", tx.nonce
  n.fromJson "gasPrice", tx.gasPrice
  n.fromJson "gas", tx.gasLimit

  if n["to"].kind != JNull:
    var to: Address
    n.fromJson "to", to
    tx.to = Opt.some(to)

  n.fromJson "value", tx.value
  n.fromJson "input", tx.payload
  n.fromJson "v", tx.V
  n.fromJson "r", tx.R
  n.fromJson "s", tx.S

  if n.hasKey("type") and n["type"].kind != JNull:
    n.fromJson "type", tx.txType

  if tx.txType >= TxEip1559:
    n.fromJson "maxPriorityFeePerGas", tx.maxPriorityFeePerGas
    n.fromJson "maxFeePerGas", tx.maxFeePerGas

  if tx.txType >= TxEip2930:
    if n.hasKey("chainId"):
      let id = parse(n["chainId"].getStr(), UInt256, 16)
      tx.chainId = id

    let accessList = n["accessList"]
    if accessList.len > 0:
      for acn in accessList:
        tx.accessList.add parseAccessPair(acn)

  if tx.txType == TxEip4844:
    n.fromJson "maxFeePerBlobGas", tx.maxFeePerBlobGas

    if n.hasKey("versionedHashes") and n["versionedHashes"].kind != JNull:
      n.fromJson "versionedHashes", tx.versionedHashes

  if tx.txType == TxEip7702:
    n.fromJson "authorizationList", tx.authorizationList

  tx

proc parseWithdrawal*(n: JsonNode): Withdrawal =
  n.fromJson "index", result.index
  n.fromJson "validatorIndex", result.validatorIndex
  n.fromJson "address", result.address
  n.fromJson "amount", result.amount

proc validateTxSenderAndHash*(n: JsonNode, tx: Transaction) =
  var sender = tx.recoverSender().expect("valid signature")
  var fromAddr: Address
  n.fromJson "from", fromAddr
  doAssert sender.to0xHex == fromAddr.to0xHex
  doAssert n["hash"].getStr() == tx.computeRlpHash().to0xHex

proc parseLog(n: JsonNode): Log =
  n.fromJson "address", result.address
  n.fromJson "data", result.data
  let topics = n["topics"]
  result.topics = newSeqOfCap[Topic](n.len)
  var topicHash: Topic
  for tp in topics:
    hexToByteArray(tp.getStr(), topicHash.data)
    result.topics.add topicHash

proc parseLogs(n: JsonNode): seq[Log] =
  if n.len > 0:
    result = newSeqOfCap[Log](n.len)
    for log in n:
      result.add parseLog(log)
  else:
    result = @[]

proc parseReceipt*(n: JsonNode): Receipt =
  var recType: byte
  n.fromJson "type", recType
  var txVal: ReceiptType
  var rec =
    if checkedEnumAssign(txVal, recType):
      Receipt(receiptType: txVal)
    else:
      raise newException(ValueError, "Unknown receipt type")

  if n.hasKey("root"):
    var hash: Hash32
    n.fromJson "root", hash
    rec.isHash = true
    rec.hash = hash
  else:
    var status: int
    n.fromJson "status", status
    rec.isHash = false
    rec.status = status == 1

  n.fromJson "cumulativeGasUsed", rec.cumulativeGasUsed
  n.fromJson "logsBloom", rec.logsBloom
  rec.logs = parseLogs(n["logs"])
  rec

proc headerHash*(n: JsonNode): Hash32 =
  n.fromJson "hash", result

proc parseAccount*(n: JsonNode): Account =
  n.fromJson "nonce", result.nonce
  n.fromJson "balance", result.balance
  n.fromJson "storageRoot", result.storageRoot
  n.fromJson "codeHash", result.codeHash
