# Fluffy
# Copyright (c) 2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.used.}

import
  stew/byteutils, testutils/unittests, ../../evm/async_evm, ./async_evm_test_backend

func hexToUInt256(s: string): UInt256 =
  UInt256.fromBytesBE(s.hexToSeqByte())

# Test state from mainnet contract 0x6e38a457c722c6011b2dfa06d49240e797844d66 at block 999962

proc setupTestEvmState(address: Address): TestEvmState =
  let
    testState = TestEvmState.init()
    code = "0x60606040526000357c0100000000000000000000000000000000000000000000000000000000900480636bd5084a1461004f578063a888c2cd14610070578063f3fe12c9146100ff5761004d565b005b61005a600450610395565b6040518082815260200191505060405180910390f35b610081600480359060200150610151565b604051808473ffffffffffffffffffffffffffffffffffffffff1681526020018060200183815260200182810382528481815481526020019150805480156100ee57820191906000526020600020905b8154815290600101906020018083116100d157829003601f168201915b505094505050505060405180910390f35b61014f6004803590602001906004018035906020019191908080601f01602080910402602001604051908101604052809392919081815260200183838082843782019150505050505090506101af565b005b60006000508181548110156100025790600052602060002090600302016000915090508060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169080600101600050908060020160005054905083565b600060006000505490506000600050805480919060010190908154818355818115116102885760030281600302836000526020600020918201910161028791906101f4565b808211156102835760006000820160006101000a81549073ffffffffffffffffffffffffffffffffffffffff021916905560018201600050805460008255601f01602090049060005260206000209081019061026e9190610250565b8082111561026a5760008181506000905550600101610250565b5090565b506002820160005060009055506001016101f4565b5090565b5b5050505060206040519081016040528033815260200183815260200143815260200150600060005082815481101561000257906000526020600020906003020160005060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690830217905550602082015181600101600050908051906020019082805482825590600052602060002090601f01602090048101928215610353579182015b82811115610352578251826000505591602001919060010190610334565b5b50905061037e9190610360565b8082111561037a5760008181506000905550600101610360565b5090565b5050604082015181600201600050559050505b5050565b600060006000505490506103a4565b9056".hexToSeqByte()

  # account balance and nonce are zero for this test case so no need to set the account

  testState.setStorage(
    address,
    "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389667".hexToUInt256(),
    "0x536174697366792056616c756573207468726f75676820467269656e64736869".hexToUInt256(),
  )
  testState.setStorage(
    address,
    "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389668".hexToUInt256(),
    "0x7020616e6420506f6e6965732100000000000000000000000000000000000000".hexToUInt256(),
  )
  testState.setStorage(
    address,
    "0x0000000000000000000000000000000000000000000000000000000000000000".hexToUInt256(),
    "0x0000000000000000000000000000000000000000000000000000000000000015".hexToUInt256(),
  )
  testState.setStorage(
    address,
    "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e578".hexToUInt256(),
    "0x000000000000000000000000fb7bc66a002762e28545ea0a7fc970d381863c42".hexToUInt256(),
  )
  testState.setStorage(
    address,
    "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e57a".hexToUInt256(),
    "0x000000000000000000000000000000000000000000000000000000000000c5df".hexToUInt256(),
  )
  testState.setStorage(
    address,
    "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e579".hexToUInt256(),
    "0x000000000000000000000000000000000000000000000000000000000000002d".hexToUInt256(),
  )

  testState.setCode(address, code)

  return testState

procSuite "Async EVM":
  let
    address = "0x6e38a457c722c6011b2dfa06d49240e797844d66".address()
    testState = setupTestEvmState(address)
    evm = AsyncEvm.init(testState.toAsyncEvmStateBackend())
    header = Header(number: 999962.uint64, gasLimit: 50_000_000.GasInt)
    callData = "0xa888c2cd0000000000000000000000000000000000000000000000000000000000000007".hexToSeqByte()
    tx = TransactionArgs(to: Opt.some(address), input: Opt.some(callData))

  asyncTest "Basic call - optimistic state fetch enabled":
    let callResult = (await evm.call(header, tx, optimisticStateFetch = true)).expect(
      "successful call"
    )
    check callResult.output ==
      "0x000000000000000000000000fb7bc66a002762e28545ea0a7fc970d381863c420000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000c5df000000000000000000000000000000000000000000000000000000000000002d536174697366792056616c756573207468726f75676820467269656e647368697020616e6420506f6e6965732100000000000000000000000000000000000000".hexToSeqByte()

  asyncTest "Basic call - optimistic state fetch disabled":
    let callResult = (await evm.call(header, tx, optimisticStateFetch = false)).expect(
      "successful call"
    )
    check callResult.output ==
      "0x000000000000000000000000fb7bc66a002762e28545ea0a7fc970d381863c420000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000c5df000000000000000000000000000000000000000000000000000000000000002d536174697366792056616c756573207468726f75676820467269656e647368697020616e6420506f6e6965732100000000000000000000000000000000000000".hexToSeqByte()

  asyncTest "Create access list - optimistic state fetch enabled":
    let (accessList, gasUsed) = (
      await evm.createAccessList(header, tx, optimisticStateFetch = true)
    ).expect("successful call")

    check:
      accessList.len() == 1
      gasUsed > 0
      accessList[0].address == address

    let storageKeys = accessList[0].storageKeys
    check:
      storageKeys.len() == 6
      storageKeys.contains(
        Bytes32.fromHex(
          "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389667"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389668"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x0000000000000000000000000000000000000000000000000000000000000000"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e578"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e57a"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e579"
        )
      )

  asyncTest "Create access list - optimistic state fetch disabled":
    let (accessList, gasUsed) = (
      await evm.createAccessList(header, tx, optimisticStateFetch = false)
    ).expect("successful call")

    check:
      accessList.len() == 1
      gasUsed > 0
      accessList[0].address == address

    let storageKeys = accessList[0].storageKeys
    check:
      storageKeys.len() == 6
      storageKeys.contains(
        Bytes32.fromHex(
          "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389667"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x80f0598597d7a1012e2e0a89cab2b766e02a3a5e30768662751fe258f5389668"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x0000000000000000000000000000000000000000000000000000000000000000"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e578"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e57a"
        )
      )
      storageKeys.contains(
        Bytes32.fromHex(
          "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e579"
        )
      )

  asyncTest "Estimate Gas - optimistic state fetch enabled":
    let gasEstimate = (await evm.estimateGas(header, tx, optimisticStateFetch = true)).expect(
      "successful call"
    )
    check gasEstimate == 22497.GasInt

  asyncTest "Estimate Gas - optimistic state fetch disabled":
    let gasEstimate = (await evm.estimateGas(header, tx, optimisticStateFetch = false)).expect(
      "successful call"
    )
    check gasEstimate == 22497.GasInt
