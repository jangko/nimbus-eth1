GeneralStateTests
===
## eip1153_tstore
```diff
+ contract_creation.json                                          OK
+ gas_usage.json                                                  OK
+ reentrant_call.json                                             OK
+ reentrant_selfdestructing_call.json                             OK
+ run_until_out_of_gas.json                                       OK
+ subcall.json                                                    OK
+ tload_after_sstore.json                                         OK
+ tload_after_tstore.json                                         OK
+ tload_after_tstore_is_zero.json                                 OK
+ transient_storage_unset_values.json                             OK
```
OK: 10/10 Fail: 0/10 Skip: 0/10
## eip1344_chainid
```diff
+ chainid.json                                                    OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## eip198_modexp_precompile
```diff
+ modexp.json                                                     OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## eip2930_access_list
```diff
+ access_list.json                                                OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## eip3651_warm_coinbase
```diff
+ warm_coinbase_call_out_of_gas.json                              OK
+ warm_coinbase_gas_usage.json                                    OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## eip3855_push0
```diff
+ push0_before_jumpdest.json                                      OK
+ push0_during_staticcall.json                                    OK
+ push0_fill_stack.json                                           OK
+ push0_gas_cost.json                                             OK
+ push0_key_sstore.json                                           OK
+ push0_stack_overflow.json                                       OK
+ push0_storage_overwrite.json                                    OK
```
OK: 7/7 Fail: 0/7 Skip: 0/7
## eip3860_initcode
```diff
+ contract_creating_tx.json                                       OK
+ create_opcode_initcode.json                                     OK
+ gas_usage.json                                                  OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## eip4844_blobs
```diff
+ blob_gas_subtraction_tx.json                                    OK
+ blob_tx_attribute_calldata_opcodes.json                         OK
+ blob_tx_attribute_gasprice_opcode.json                          OK
+ blob_tx_attribute_opcodes.json                                  OK
+ blob_tx_attribute_value_opcode.json                             OK
+ blob_type_tx_pre_fork.json                                      OK
+ insufficient_balance_blob_tx.json                               OK
+ invalid_blob_hash_versioning_single_tx.json                     OK
+ invalid_normal_gas.json                                         OK
+ invalid_precompile_calls.json                                   OK
+ invalid_tx_blob_count.json                                      OK
+ invalid_tx_max_fee_per_blob_gas_state.json                      OK
+ point_evaluation_precompile_before_fork.json                    OK
+ point_evaluation_precompile_calls.json                          OK
+ point_evaluation_precompile_external_vectors.json               OK
+ point_evaluation_precompile_gas_tx_to.json                      OK
+ point_evaluation_precompile_gas_usage.json                      OK
+ sufficient_balance_blob_tx.json                                 OK
+ valid_precompile_calls.json                                     OK
```
OK: 19/19 Fail: 0/19 Skip: 0/19
## eip5656_mcopy
```diff
+ mcopy_huge_memory_expansion.json                                OK
+ mcopy_memory_expansion.json                                     OK
+ mcopy_on_empty_memory.json                                      OK
+ no_memory_corruption_on_upper_call_stack_levels.json            OK
+ valid_mcopy_operations.json                                     OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## eip6780_selfdestruct
```diff
+ create_selfdestruct_same_tx.json                                OK
+ delegatecall_from_new_contract_to_pre_existing_contract.json    OK
+ delegatecall_from_pre_existing_contract_to_new_contract.json    OK
+ dynamic_create2_selfdestruct_collision.json                     OK
+ reentrancy_selfdestruct_revert.json                             OK
+ self_destructing_initcode.json                                  OK
+ self_destructing_initcode_create_tx.json                        OK
+ selfdestruct_created_in_same_tx_with_revert.json                OK
+ selfdestruct_not_created_in_same_tx_with_revert.json            OK
+ selfdestruct_pre_existing.json                                  OK
```
OK: 10/10 Fail: 0/10 Skip: 0/10
## eip7516_blobgasfee
```diff
+ blobbasefee_before_fork.json                                    OK
+ blobbasefee_out_of_gas.json                                     OK
+ blobbasefee_stack_overflow.json                                 OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## opcodes
```diff
+ dup.json                                                        OK
+ value_transfer_gas_calculation.json                             OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## stArgsZeroOneBalance
```diff
+ addNonConst.json                                                OK
+ addmodNonConst.json                                             OK
+ andNonConst.json                                                OK
+ balanceNonConst.json                                            OK
+ byteNonConst.json                                               OK
+ callNonConst.json                                               OK
+ callcodeNonConst.json                                           OK
+ calldatacopyNonConst.json                                       OK
+ calldataloadNonConst.json                                       OK
+ codecopyNonConst.json                                           OK
+ createNonConst.json                                             OK
+ delegatecallNonConst.json                                       OK
+ divNonConst.json                                                OK
+ eqNonConst.json                                                 OK
+ expNonConst.json                                                OK
+ extcodecopyNonConst.json                                        OK
+ extcodesizeNonConst.json                                        OK
+ gtNonConst.json                                                 OK
+ iszeroNonConst.json                                             OK
+ jumpNonConst.json                                               OK
+ jumpiNonConst.json                                              OK
+ log0NonConst.json                                               OK
+ log1NonConst.json                                               OK
+ log2NonConst.json                                               OK
+ log3NonConst.json                                               OK
+ ltNonConst.json                                                 OK
+ mloadNonConst.json                                              OK
+ modNonConst.json                                                OK
+ mstore8NonConst.json                                            OK
+ mstoreNonConst.json                                             OK
+ mulNonConst.json                                                OK
+ mulmodNonConst.json                                             OK
+ notNonConst.json                                                OK
+ orNonConst.json                                                 OK
+ returnNonConst.json                                             OK
+ sdivNonConst.json                                               OK
+ sgtNonConst.json                                                OK
+ sha3NonConst.json                                               OK
+ signextNonConst.json                                            OK
+ sloadNonConst.json                                              OK
+ sltNonConst.json                                                OK
+ smodNonConst.json                                               OK
+ sstoreNonConst.json                                             OK
+ subNonConst.json                                                OK
+ suicideNonConst.json                                            OK
+ xorNonConst.json                                                OK
```
OK: 46/46 Fail: 0/46 Skip: 0/46
## stAttackTest
```diff
  ContractCreationSpam.json                                       Skip
+ CrashingTransaction.json                                        OK
```
OK: 1/2 Fail: 0/2 Skip: 1/2
## stBadOpcode
```diff
+ badOpcodes.json                                                 OK
+ eip2315NotRemoved.json                                          OK
+ invalidAddr.json                                                OK
+ invalidDiffPlaces.json                                          OK
+ measureGas.json                                                 OK
+ opc0CDiffPlaces.json                                            OK
+ opc0DDiffPlaces.json                                            OK
+ opc0EDiffPlaces.json                                            OK
+ opc0FDiffPlaces.json                                            OK
+ opc1EDiffPlaces.json                                            OK
+ opc1FDiffPlaces.json                                            OK
+ opc21DiffPlaces.json                                            OK
+ opc22DiffPlaces.json                                            OK
+ opc23DiffPlaces.json                                            OK
+ opc24DiffPlaces.json                                            OK
+ opc25DiffPlaces.json                                            OK
+ opc26DiffPlaces.json                                            OK
+ opc27DiffPlaces.json                                            OK
+ opc28DiffPlaces.json                                            OK
+ opc29DiffPlaces.json                                            OK
+ opc2ADiffPlaces.json                                            OK
+ opc2BDiffPlaces.json                                            OK
+ opc2CDiffPlaces.json                                            OK
+ opc2DDiffPlaces.json                                            OK
+ opc2EDiffPlaces.json                                            OK
+ opc2FDiffPlaces.json                                            OK
+ opc49DiffPlaces.json                                            OK
+ opc4ADiffPlaces.json                                            OK
+ opc4BDiffPlaces.json                                            OK
+ opc4CDiffPlaces.json                                            OK
+ opc4DDiffPlaces.json                                            OK
+ opc4EDiffPlaces.json                                            OK
+ opc4FDiffPlaces.json                                            OK
+ opc5CDiffPlaces.json                                            OK
+ opc5DDiffPlaces.json                                            OK
+ opc5EDiffPlaces.json                                            OK
+ opc5FDiffPlaces.json                                            OK
+ opcA5DiffPlaces.json                                            OK
+ opcA6DiffPlaces.json                                            OK
+ opcA7DiffPlaces.json                                            OK
+ opcA8DiffPlaces.json                                            OK
+ opcA9DiffPlaces.json                                            OK
+ opcAADiffPlaces.json                                            OK
+ opcABDiffPlaces.json                                            OK
+ opcACDiffPlaces.json                                            OK
+ opcADDiffPlaces.json                                            OK
+ opcAEDiffPlaces.json                                            OK
+ opcAFDiffPlaces.json                                            OK
+ opcB0DiffPlaces.json                                            OK
+ opcB1DiffPlaces.json                                            OK
+ opcB2DiffPlaces.json                                            OK
+ opcB3DiffPlaces.json                                            OK
+ opcB4DiffPlaces.json                                            OK
+ opcB5DiffPlaces.json                                            OK
+ opcB6DiffPlaces.json                                            OK
+ opcB7DiffPlaces.json                                            OK
+ opcB8DiffPlaces.json                                            OK
+ opcB9DiffPlaces.json                                            OK
+ opcBADiffPlaces.json                                            OK
+ opcBBDiffPlaces.json                                            OK
+ opcBCDiffPlaces.json                                            OK
+ opcBDDiffPlaces.json                                            OK
+ opcBEDiffPlaces.json                                            OK
+ opcBFDiffPlaces.json                                            OK
+ opcC0DiffPlaces.json                                            OK
+ opcC1DiffPlaces.json                                            OK
+ opcC2DiffPlaces.json                                            OK
+ opcC3DiffPlaces.json                                            OK
+ opcC4DiffPlaces.json                                            OK
+ opcC5DiffPlaces.json                                            OK
+ opcC6DiffPlaces.json                                            OK
+ opcC7DiffPlaces.json                                            OK
+ opcC8DiffPlaces.json                                            OK
+ opcC9DiffPlaces.json                                            OK
+ opcCADiffPlaces.json                                            OK
+ opcCBDiffPlaces.json                                            OK
+ opcCCDiffPlaces.json                                            OK
+ opcCDDiffPlaces.json                                            OK
+ opcCEDiffPlaces.json                                            OK
+ opcCFDiffPlaces.json                                            OK
+ opcD0DiffPlaces.json                                            OK
+ opcD1DiffPlaces.json                                            OK
+ opcD2DiffPlaces.json                                            OK
+ opcD3DiffPlaces.json                                            OK
+ opcD4DiffPlaces.json                                            OK
+ opcD5DiffPlaces.json                                            OK
+ opcD6DiffPlaces.json                                            OK
+ opcD7DiffPlaces.json                                            OK
+ opcD8DiffPlaces.json                                            OK
+ opcD9DiffPlaces.json                                            OK
+ opcDADiffPlaces.json                                            OK
+ opcDBDiffPlaces.json                                            OK
+ opcDCDiffPlaces.json                                            OK
+ opcDDDiffPlaces.json                                            OK
+ opcDEDiffPlaces.json                                            OK
+ opcDFDiffPlaces.json                                            OK
+ opcE0DiffPlaces.json                                            OK
+ opcE1DiffPlaces.json                                            OK
+ opcE2DiffPlaces.json                                            OK
+ opcE3DiffPlaces.json                                            OK
+ opcE4DiffPlaces.json                                            OK
+ opcE5DiffPlaces.json                                            OK
+ opcE6DiffPlaces.json                                            OK
+ opcE7DiffPlaces.json                                            OK
+ opcE8DiffPlaces.json                                            OK
+ opcE9DiffPlaces.json                                            OK
+ opcEADiffPlaces.json                                            OK
+ opcEBDiffPlaces.json                                            OK
+ opcECDiffPlaces.json                                            OK
+ opcEDDiffPlaces.json                                            OK
+ opcEEDiffPlaces.json                                            OK
+ opcEFDiffPlaces.json                                            OK
+ opcF6DiffPlaces.json                                            OK
+ opcF7DiffPlaces.json                                            OK
+ opcF8DiffPlaces.json                                            OK
+ opcF9DiffPlaces.json                                            OK
+ opcFBDiffPlaces.json                                            OK
+ opcFCDiffPlaces.json                                            OK
+ opcFEDiffPlaces.json                                            OK
+ operationDiffGas.json                                           OK
+ undefinedOpcodeFirstByte.json                                   OK
```
OK: 121/121 Fail: 0/121 Skip: 0/121
## stBugs
```diff
+ evmBytecode.json                                                OK
+ randomStatetestDEFAULT-Tue_07_58_41-15153-575192.json           OK
+ randomStatetestDEFAULT-Tue_07_58_41-15153-575192_london.json    OK
+ returndatacopyPythonBug_Tue_03_48_41-1432.json                  OK
+ staticcall_createfails.json                                     OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## stCallCodes
```diff
+ call_OOG_additionalGasCosts1.json                               OK
+ call_OOG_additionalGasCosts2.json                               OK
+ callcall_00.json                                                OK
+ callcall_00_OOGE.json                                           OK
+ callcall_00_OOGE_valueTransfer.json                             OK
+ callcall_00_SuicideEnd.json                                     OK
+ callcallcall_000.json                                           OK
+ callcallcall_000_OOGE.json                                      OK
+ callcallcall_000_OOGMAfter.json                                 OK
+ callcallcall_000_OOGMBefore.json                                OK
+ callcallcall_000_SuicideEnd.json                                OK
+ callcallcall_000_SuicideMiddle.json                             OK
+ callcallcall_ABCB_RECURSIVE.json                                OK
+ callcallcallcode_001.json                                       OK
+ callcallcallcode_001_OOGE.json                                  OK
+ callcallcallcode_001_OOGMAfter.json                             OK
+ callcallcallcode_001_OOGMBefore.json                            OK
+ callcallcallcode_001_SuicideEnd.json                            OK
+ callcallcallcode_001_SuicideMiddle.json                         OK
  callcallcallcode_ABCB_RECURSIVE.json                            Skip
+ callcallcode_01.json                                            OK
+ callcallcode_01_OOGE.json                                       OK
+ callcallcode_01_SuicideEnd.json                                 OK
+ callcallcodecall_010.json                                       OK
+ callcallcodecall_010_OOGE.json                                  OK
+ callcallcodecall_010_OOGMAfter.json                             OK
+ callcallcodecall_010_OOGMBefore.json                            OK
+ callcallcodecall_010_SuicideEnd.json                            OK
+ callcallcodecall_010_SuicideMiddle.json                         OK
  callcallcodecall_ABCB_RECURSIVE.json                            Skip
+ callcallcodecallcode_011.json                                   OK
+ callcallcodecallcode_011_OOGE.json                              OK
+ callcallcodecallcode_011_OOGMAfter.json                         OK
+ callcallcodecallcode_011_OOGMBefore.json                        OK
+ callcallcodecallcode_011_SuicideEnd.json                        OK
+ callcallcodecallcode_011_SuicideMiddle.json                     OK
  callcallcodecallcode_ABCB_RECURSIVE.json                        Skip
+ callcodeDynamicCode.json                                        OK
+ callcodeDynamicCode2SelfCall.json                               OK
+ callcodeEmptycontract.json                                      OK
+ callcodeInInitcodeToEmptyContract.json                          OK
+ callcodeInInitcodeToExisContractWithVTransferNEMoney.json       OK
+ callcodeInInitcodeToExistingContract.json                       OK
+ callcodeInInitcodeToExistingContractWithValueTransfer.json      OK
+ callcode_checkPC.json                                           OK
+ callcodecall_10.json                                            OK
+ callcodecall_10_OOGE.json                                       OK
+ callcodecall_10_SuicideEnd.json                                 OK
+ callcodecallcall_100.json                                       OK
+ callcodecallcall_100_OOGE.json                                  OK
+ callcodecallcall_100_OOGMAfter.json                             OK
+ callcodecallcall_100_OOGMBefore.json                            OK
+ callcodecallcall_100_SuicideEnd.json                            OK
+ callcodecallcall_100_SuicideMiddle.json                         OK
  callcodecallcall_ABCB_RECURSIVE.json                            Skip
+ callcodecallcallcode_101.json                                   OK
+ callcodecallcallcode_101_OOGE.json                              OK
+ callcodecallcallcode_101_OOGMAfter.json                         OK
+ callcodecallcallcode_101_OOGMBefore.json                        OK
+ callcodecallcallcode_101_SuicideEnd.json                        OK
+ callcodecallcallcode_101_SuicideMiddle.json                     OK
  callcodecallcallcode_ABCB_RECURSIVE.json                        Skip
+ callcodecallcode_11.json                                        OK
+ callcodecallcode_11_OOGE.json                                   OK
+ callcodecallcode_11_SuicideEnd.json                             OK
+ callcodecallcodecall_110.json                                   OK
+ callcodecallcodecall_110_OOGE.json                              OK
+ callcodecallcodecall_110_OOGMAfter.json                         OK
+ callcodecallcodecall_110_OOGMBefore.json                        OK
+ callcodecallcodecall_110_SuicideEnd.json                        OK
+ callcodecallcodecall_110_SuicideMiddle.json                     OK
  callcodecallcodecall_ABCB_RECURSIVE.json                        Skip
+ callcodecallcodecallcode_111.json                               OK
+ callcodecallcodecallcode_111_OOGE.json                          OK
+ callcodecallcodecallcode_111_OOGMAfter.json                     OK
+ callcodecallcodecallcode_111_OOGMBefore.json                    OK
+ callcodecallcodecallcode_111_SuicideEnd.json                    OK
+ callcodecallcodecallcode_111_SuicideMiddle.json                 OK
  callcodecallcodecallcode_ABCB_RECURSIVE.json                    Skip
+ touchAndGo.json                                                 OK
```
OK: 73/80 Fail: 0/80 Skip: 7/80
## stCallCreateCallCodeTest
```diff
  Call1024BalanceTooLow.json                                      Skip
  Call1024OOG.json                                                Skip
  Call1024PreCalls.json                                           Skip
+ CallLoseGasOOG.json                                             OK
  CallRecursiveBombPreCall.json                                   Skip
  Callcode1024BalanceTooLow.json                                  Skip
  Callcode1024OOG.json                                            Skip
+ CallcodeLoseGasOOG.json                                         OK
+ callOutput1.json                                                OK
+ callOutput2.json                                                OK
+ callOutput3.json                                                OK
+ callOutput3Fail.json                                            OK
+ callOutput3partial.json                                         OK
+ callOutput3partialFail.json                                     OK
+ callWithHighValue.json                                          OK
+ callWithHighValueAndGasOOG.json                                 OK
+ callWithHighValueAndOOGatTxLevel.json                           OK
+ callWithHighValueOOGinCall.json                                 OK
+ callcodeOutput1.json                                            OK
+ callcodeOutput2.json                                            OK
+ callcodeOutput3.json                                            OK
+ callcodeOutput3Fail.json                                        OK
+ callcodeOutput3partial.json                                     OK
+ callcodeOutput3partialFail.json                                 OK
+ callcodeWithHighValue.json                                      OK
+ callcodeWithHighValueAndGasOOG.json                             OK
+ contractCreationMakeCallThatAskMoreGasThenTransactionProvided.j OK
+ createFailBalanceTooLow.json                                    OK
+ createInitFailBadJumpDestination.json                           OK
+ createInitFailBadJumpDestination2.json                          OK
+ createInitFailStackSizeLargerThan1024.json                      OK
+ createInitFailStackUnderflow.json                               OK
+ createInitFailUndefinedInstruction.json                         OK
+ createInitFailUndefinedInstruction2.json                        OK
+ createInitFail_OOGduringInit.json                               OK
+ createInitFail_OOGduringInit2.json                              OK
+ createInitOOGforCREATE.json                                     OK
+ createJS_ExampleContract.json                                   OK
+ createJS_NoCollision.json                                       OK
+ createNameRegistratorPerTxs.json                                OK
+ createNameRegistratorPerTxsNotEnoughGas.json                    OK
+ createNameRegistratorPreStore1NotEnoughGas.json                 OK
+ createNameRegistratorendowmentTooHigh.json                      OK
```
OK: 37/43 Fail: 0/43 Skip: 6/43
## stCallDelegateCodesCallCodeHomestead
```diff
+ callcallcallcode_001.json                                       OK
+ callcallcallcode_001_OOGE.json                                  OK
+ callcallcallcode_001_OOGMAfter.json                             OK
+ callcallcallcode_001_OOGMBefore.json                            OK
+ callcallcallcode_001_SuicideEnd.json                            OK
+ callcallcallcode_001_SuicideMiddle.json                         OK
  callcallcallcode_ABCB_RECURSIVE.json                            Skip
+ callcallcode_01.json                                            OK
+ callcallcode_01_OOGE.json                                       OK
+ callcallcode_01_SuicideEnd.json                                 OK
+ callcallcodecall_010.json                                       OK
+ callcallcodecall_010_OOGE.json                                  OK
+ callcallcodecall_010_OOGMAfter.json                             OK
+ callcallcodecall_010_OOGMBefore.json                            OK
+ callcallcodecall_010_SuicideEnd.json                            OK
+ callcallcodecall_010_SuicideMiddle.json                         OK
  callcallcodecall_ABCB_RECURSIVE.json                            Skip
+ callcallcodecallcode_011.json                                   OK
+ callcallcodecallcode_011_OOGE.json                              OK
+ callcallcodecallcode_011_OOGMAfter.json                         OK
+ callcallcodecallcode_011_OOGMBefore.json                        OK
+ callcallcodecallcode_011_SuicideEnd.json                        OK
+ callcallcodecallcode_011_SuicideMiddle.json                     OK
  callcallcodecallcode_ABCB_RECURSIVE.json                        Skip
+ callcodecall_10.json                                            OK
+ callcodecall_10_OOGE.json                                       OK
+ callcodecall_10_SuicideEnd.json                                 OK
+ callcodecallcall_100.json                                       OK
+ callcodecallcall_100_OOGE.json                                  OK
+ callcodecallcall_100_OOGMAfter.json                             OK
+ callcodecallcall_100_OOGMBefore.json                            OK
+ callcodecallcall_100_SuicideEnd.json                            OK
+ callcodecallcall_100_SuicideMiddle.json                         OK
  callcodecallcall_ABCB_RECURSIVE.json                            Skip
+ callcodecallcallcode_101.json                                   OK
+ callcodecallcallcode_101_OOGE.json                              OK
+ callcodecallcallcode_101_OOGMAfter.json                         OK
+ callcodecallcallcode_101_OOGMBefore.json                        OK
+ callcodecallcallcode_101_SuicideEnd.json                        OK
+ callcodecallcallcode_101_SuicideMiddle.json                     OK
  callcodecallcallcode_ABCB_RECURSIVE.json                        Skip
+ callcodecallcode_11.json                                        OK
+ callcodecallcode_11_OOGE.json                                   OK
+ callcodecallcode_11_SuicideEnd.json                             OK
+ callcodecallcodecall_110.json                                   OK
+ callcodecallcodecall_110_OOGE.json                              OK
+ callcodecallcodecall_110_OOGMAfter.json                         OK
+ callcodecallcodecall_110_OOGMBefore.json                        OK
+ callcodecallcodecall_110_SuicideEnd.json                        OK
+ callcodecallcodecall_110_SuicideMiddle.json                     OK
  callcodecallcodecall_ABCB_RECURSIVE.json                        Skip
+ callcodecallcodecallcode_111.json                               OK
+ callcodecallcodecallcode_111_OOGE.json                          OK
+ callcodecallcodecallcode_111_OOGMAfter.json                     OK
+ callcodecallcodecallcode_111_OOGMBefore.json                    OK
+ callcodecallcodecallcode_111_SuicideEnd.json                    OK
+ callcodecallcodecallcode_111_SuicideMiddle.json                 OK
  callcodecallcodecallcode_ABCB_RECURSIVE.json                    Skip
```
OK: 51/58 Fail: 0/58 Skip: 7/58
## stCallDelegateCodesHomestead
```diff
+ callcallcallcode_001.json                                       OK
+ callcallcallcode_001_OOGE.json                                  OK
+ callcallcallcode_001_OOGMAfter.json                             OK
+ callcallcallcode_001_OOGMBefore.json                            OK
+ callcallcallcode_001_SuicideEnd.json                            OK
+ callcallcallcode_001_SuicideMiddle.json                         OK
  callcallcallcode_ABCB_RECURSIVE.json                            Skip
+ callcallcode_01.json                                            OK
+ callcallcode_01_OOGE.json                                       OK
+ callcallcode_01_SuicideEnd.json                                 OK
+ callcallcodecall_010.json                                       OK
+ callcallcodecall_010_OOGE.json                                  OK
+ callcallcodecall_010_OOGMAfter.json                             OK
+ callcallcodecall_010_OOGMBefore.json                            OK
+ callcallcodecall_010_SuicideEnd.json                            OK
+ callcallcodecall_010_SuicideMiddle.json                         OK
  callcallcodecall_ABCB_RECURSIVE.json                            Skip
+ callcallcodecallcode_011.json                                   OK
+ callcallcodecallcode_011_OOGE.json                              OK
+ callcallcodecallcode_011_OOGMAfter.json                         OK
+ callcallcodecallcode_011_OOGMBefore.json                        OK
+ callcallcodecallcode_011_SuicideEnd.json                        OK
+ callcallcodecallcode_011_SuicideMiddle.json                     OK
  callcallcodecallcode_ABCB_RECURSIVE.json                        Skip
+ callcodecall_10.json                                            OK
+ callcodecall_10_OOGE.json                                       OK
+ callcodecall_10_SuicideEnd.json                                 OK
+ callcodecallcall_100.json                                       OK
+ callcodecallcall_100_OOGE.json                                  OK
+ callcodecallcall_100_OOGMAfter.json                             OK
+ callcodecallcall_100_OOGMBefore.json                            OK
+ callcodecallcall_100_SuicideEnd.json                            OK
+ callcodecallcall_100_SuicideMiddle.json                         OK
  callcodecallcall_ABCB_RECURSIVE.json                            Skip
+ callcodecallcallcode_101.json                                   OK
+ callcodecallcallcode_101_OOGE.json                              OK
+ callcodecallcallcode_101_OOGMAfter.json                         OK
+ callcodecallcallcode_101_OOGMBefore.json                        OK
+ callcodecallcallcode_101_SuicideEnd.json                        OK
+ callcodecallcallcode_101_SuicideMiddle.json                     OK
  callcodecallcallcode_ABCB_RECURSIVE.json                        Skip
+ callcodecallcode_11.json                                        OK
+ callcodecallcode_11_OOGE.json                                   OK
+ callcodecallcode_11_SuicideEnd.json                             OK
+ callcodecallcodecall_110.json                                   OK
+ callcodecallcodecall_110_OOGE.json                              OK
+ callcodecallcodecall_110_OOGMAfter.json                         OK
+ callcodecallcodecall_110_OOGMBefore.json                        OK
+ callcodecallcodecall_110_SuicideEnd.json                        OK
+ callcodecallcodecall_110_SuicideMiddle.json                     OK
  callcodecallcodecall_ABCB_RECURSIVE.json                        Skip
+ callcodecallcodecallcode_111.json                               OK
+ callcodecallcodecallcode_111_OOGE.json                          OK
+ callcodecallcodecallcode_111_OOGMAfter.json                     OK
+ callcodecallcodecallcode_111_OOGMBefore.json                    OK
+ callcodecallcodecallcode_111_SuicideEnd.json                    OK
+ callcodecallcodecallcode_111_SuicideMiddle.json                 OK
  callcodecallcodecallcode_ABCB_RECURSIVE.json                    Skip
```
OK: 51/58 Fail: 0/58 Skip: 7/58
## stChainId
```diff
+ chainId.json                                                    OK
+ chainIdGasCost.json                                             OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## stCodeCopyTest
```diff
+ ExtCodeCopyTargetRangeLongerThanCodeTests.json                  OK
+ ExtCodeCopyTests.json                                           OK
+ ExtCodeCopyTestsParis.json                                      OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## stCodeSizeLimit
```diff
+ codesizeInit.json                                               OK
+ codesizeOOGInvalidSize.json                                     OK
+ codesizeValid.json                                              OK
+ create2CodeSizeLimit.json                                       OK
+ createCodeSizeLimit.json                                        OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## stCreate2
```diff
+ CREATE2_Bounds.json                                             OK
+ CREATE2_Bounds2.json                                            OK
+ CREATE2_Bounds3.json                                            OK
+ CREATE2_ContractSuicideDuringInit_ThenStoreThenReturn.json      OK
+ CREATE2_FirstByte_loop.json                                     OK
+ CREATE2_HighNonce.json                                          OK
+ CREATE2_HighNonceDelegatecall.json                              OK
+ CREATE2_HighNonceMinus1.json                                    OK
+ CREATE2_Suicide.json                                            OK
+ Create2OOGFromCallRefunds.json                                  OK
+ Create2OOGafterInitCode.json                                    OK
+ Create2OOGafterInitCodeReturndata.json                          OK
+ Create2OOGafterInitCodeReturndata2.json                         OK
+ Create2OOGafterInitCodeReturndata3.json                         OK
+ Create2OOGafterInitCodeReturndataSize.json                      OK
+ Create2OOGafterInitCodeRevert.json                              OK
+ Create2OOGafterInitCodeRevert2.json                             OK
+ Create2OnDepth1023.json                                         OK
+ Create2OnDepth1024.json                                         OK
  Create2Recursive.json                                           Skip
+ CreateMessageReverted.json                                      OK
+ CreateMessageRevertedOOGInInit.json                             OK
+ CreateMessageRevertedOOGInInit2.json                            OK
+ RevertDepthCreate2OOG.json                                      OK
+ RevertDepthCreate2OOGBerlin.json                                OK
+ RevertDepthCreateAddressCollision.json                          OK
+ RevertDepthCreateAddressCollisionBerlin.json                    OK
+ RevertInCreateInInitCreate2.json                                OK
+ RevertInCreateInInitCreate2Paris.json                           OK
+ RevertOpcodeCreate.json                                         OK
+ RevertOpcodeInCreateReturnsCreate2.json                         OK
+ call_outsize_then_create2_successful_then_returndatasize.json   OK
+ call_then_create2_successful_then_returndatasize.json           OK
+ create2InitCodes.json                                           OK
+ create2SmartInitCode.json                                       OK
+ create2callPrecompiles.json                                     OK
+ create2checkFieldsInInitcode.json                               OK
+ create2collisionBalance.json                                    OK
+ create2collisionCode.json                                       OK
+ create2collisionCode2.json                                      OK
+ create2collisionNonce.json                                      OK
+ create2collisionSelfdestructed.json                             OK
+ create2collisionSelfdestructed2.json                            OK
+ create2collisionSelfdestructedOOG.json                          OK
+ create2collisionSelfdestructedRevert.json                       OK
+ create2collisionStorage.json                                    OK
+ create2collisionStorageParis.json                               OK
+ create2noCash.json                                              OK
+ returndatacopy_0_0_following_successful_create.json             OK
+ returndatacopy_afterFailing_create.json                         OK
+ returndatacopy_following_create.json                            OK
+ returndatacopy_following_revert_in_create.json                  OK
+ returndatacopy_following_successful_create.json                 OK
+ returndatasize_following_successful_create.json                 OK
```
OK: 53/54 Fail: 0/54 Skip: 1/54
## stCreateTest
```diff
+ CREATE2_CallData.json                                           OK
+ CREATE2_RefundEF.json                                           OK
+ CREATE_AcreateB_BSuicide_BStore.json                            OK
+ CREATE_ContractRETURNBigOffset.json                             OK
+ CREATE_ContractSSTOREDuringInit.json                            OK
+ CREATE_ContractSuicideDuringInit.json                           OK
+ CREATE_ContractSuicideDuringInit_ThenStoreThenReturn.json       OK
+ CREATE_ContractSuicideDuringInit_WithValue.json                 OK
+ CREATE_ContractSuicideDuringInit_WithValueToItself.json         OK
+ CREATE_EContractCreateEContractInInit_Tr.json                   OK
+ CREATE_EContractCreateNEContractInInitOOG_Tr.json               OK
+ CREATE_EContractCreateNEContractInInit_Tr.json                  OK
+ CREATE_EContract_ThenCALLToNonExistentAcc.json                  OK
+ CREATE_EmptyContract.json                                       OK
+ CREATE_EmptyContractAndCallIt_0wei.json                         OK
+ CREATE_EmptyContractAndCallIt_1wei.json                         OK
+ CREATE_EmptyContractWithBalance.json                            OK
+ CREATE_EmptyContractWithStorage.json                            OK
+ CREATE_EmptyContractWithStorageAndCallIt_0wei.json              OK
+ CREATE_EmptyContractWithStorageAndCallIt_1wei.json              OK
+ CREATE_FirstByte_loop.json                                      OK
+ CREATE_HighNonce.json                                           OK
+ CREATE_HighNonceMinus1.json                                     OK
+ CREATE_empty000CreateinInitCode_Transaction.json                OK
+ CodeInConstructor.json                                          OK
+ CreateAddressWarmAfterFail.json                                 OK
+ CreateCollisionResults.json                                     OK
+ CreateCollisionToEmpty.json                                     OK
+ CreateCollisionToEmpty2.json                                    OK
+ CreateOOGFromCallRefunds.json                                   OK
+ CreateOOGFromEOARefunds.json                                    OK
+ CreateOOGafterInitCode.json                                     OK
+ CreateOOGafterInitCodeReturndata.json                           OK
+ CreateOOGafterInitCodeReturndata2.json                          OK
+ CreateOOGafterInitCodeReturndata3.json                          OK
+ CreateOOGafterInitCodeReturndataSize.json                       OK
+ CreateOOGafterInitCodeRevert.json                               OK
+ CreateOOGafterInitCodeRevert2.json                              OK
+ CreateOOGafterMaxCodesize.json                                  OK
+ CreateResults.json                                              OK
+ CreateTransactionCallData.json                                  OK
+ CreateTransactionHighNonce.json                                 OK
+ CreateTransactionRefundEF.json                                  OK
+ TransactionCollisionToEmpty.json                                OK
+ TransactionCollisionToEmpty2.json                               OK
+ TransactionCollisionToEmptyButCode.json                         OK
+ TransactionCollisionToEmptyButNonce.json                        OK
+ createFailResult.json                                           OK
+ createLargeResult.json                                          OK
```
OK: 49/49 Fail: 0/49 Skip: 0/49
## stDelegatecallTestHomestead
```diff
  Call1024BalanceTooLow.json                                      Skip
  Call1024OOG.json                                                Skip
  Call1024PreCalls.json                                           Skip
+ CallLoseGasOOG.json                                             OK
  CallRecursiveBombPreCall.json                                   Skip
+ CallcodeLoseGasOOG.json                                         OK
  Delegatecall1024.json                                           Skip
  Delegatecall1024OOG.json                                        Skip
+ callOutput1.json                                                OK
+ callOutput2.json                                                OK
+ callOutput3.json                                                OK
+ callOutput3partial.json                                         OK
+ callOutput3partialFail.json                                     OK
+ callWithHighValueAndGasOOG.json                                 OK
+ callcodeOutput3.json                                            OK
+ callcodeWithHighValueAndGasOOG.json                             OK
+ deleagateCallAfterValueTransfer.json                            OK
+ delegatecallAndOOGatTxLevel.json                                OK
+ delegatecallBasic.json                                          OK
+ delegatecallEmptycontract.json                                  OK
+ delegatecallInInitcodeToEmptyContract.json                      OK
+ delegatecallInInitcodeToExistingContract.json                   OK
+ delegatecallInInitcodeToExistingContractOOG.json                OK
+ delegatecallOOGinCall.json                                      OK
+ delegatecallSenderCheck.json                                    OK
+ delegatecallValueCheck.json                                     OK
+ delegatecodeDynamicCode.json                                    OK
+ delegatecodeDynamicCode2SelfCall.json                           OK
```
OK: 22/28 Fail: 0/28 Skip: 6/28
## stEIP1153-transientStorage
```diff
+ 01_tloadBeginningTxn.json                                       OK
+ 02_tloadAfterTstore.json                                        OK
+ 03_tloadAfterStoreIs0.json                                      OK
+ 04_tloadAfterCall.json                                          OK
+ 05_tloadReentrancy.json                                         OK
+ 06_tstoreInReentrancyCall.json                                  OK
+ 07_tloadAfterReentrancyStore.json                               OK
+ 08_revertUndoesTransientStore.json                              OK
+ 09_revertUndoesAll.json                                         OK
+ 10_revertUndoesStoreAfterReturn.json                            OK
+ 11_tstoreDelegateCall.json                                      OK
+ 12_tloadDelegateCall.json                                       OK
+ 13_tloadStaticCall.json                                         OK
+ 14_revertAfterNestedStaticcall.json                             OK
+ 15_tstoreCannotBeDosd.json                                      OK
+ 16_tloadGas.json                                                OK
+ 17_tstoreGas.json                                               OK
+ 18_tloadAfterStore.json                                         OK
+ 19_oogUndoesTransientStore.json                                 OK
+ 20_oogUndoesTransientStoreInCall.json                           OK
+ 21_tstoreCannotBeDosdOOO.json                                   OK
+ transStorageOK.json                                             OK
+ transStorageReset.json                                          OK
```
OK: 23/23 Fail: 0/23 Skip: 0/23
## stEIP150Specific
```diff
+ CallAndCallcodeConsumeMoreGasThenTransactionHas.json            OK
+ CallAskMoreGasOnDepth2ThenTransactionHas.json                   OK
+ CallGoesOOGOnSecondLevel.json                                   OK
+ CallGoesOOGOnSecondLevel2.json                                  OK
+ CreateAndGasInsideCreate.json                                   OK
+ DelegateCallOnEIP.json                                          OK
+ ExecuteCallThatAskForeGasThenTrabsactionHas.json                OK
+ NewGasPriceForCodes.json                                        OK
+ SuicideToExistingContract.json                                  OK
+ SuicideToNotExistingContract.json                               OK
+ Transaction64Rule_d64e0.json                                    OK
+ Transaction64Rule_d64m1.json                                    OK
+ Transaction64Rule_d64p1.json                                    OK
+ Transaction64Rule_integerBoundaries.json                        OK
```
OK: 14/14 Fail: 0/14 Skip: 0/14
## stEIP150singleCodeGasPrices
```diff
+ RawBalanceGas.json                                              OK
+ RawCallCodeGas.json                                             OK
+ RawCallCodeGasAsk.json                                          OK
+ RawCallCodeGasMemory.json                                       OK
+ RawCallCodeGasMemoryAsk.json                                    OK
+ RawCallCodeGasValueTransfer.json                                OK
+ RawCallCodeGasValueTransferAsk.json                             OK
+ RawCallCodeGasValueTransferMemory.json                          OK
+ RawCallCodeGasValueTransferMemoryAsk.json                       OK
+ RawCallGas.json                                                 OK
+ RawCallGasAsk.json                                              OK
+ RawCallGasValueTransfer.json                                    OK
+ RawCallGasValueTransferAsk.json                                 OK
+ RawCallGasValueTransferMemory.json                              OK
+ RawCallGasValueTransferMemoryAsk.json                           OK
+ RawCallMemoryGas.json                                           OK
+ RawCallMemoryGasAsk.json                                        OK
+ RawCreateFailGasValueTransfer.json                              OK
+ RawCreateFailGasValueTransfer2.json                             OK
+ RawCreateGas.json                                               OK
+ RawCreateGasMemory.json                                         OK
+ RawCreateGasValueTransfer.json                                  OK
+ RawCreateGasValueTransferMemory.json                            OK
+ RawDelegateCallGas.json                                         OK
+ RawDelegateCallGasAsk.json                                      OK
+ RawDelegateCallGasMemory.json                                   OK
+ RawDelegateCallGasMemoryAsk.json                                OK
+ RawExtCodeCopyGas.json                                          OK
+ RawExtCodeCopyMemoryGas.json                                    OK
+ RawExtCodeSizeGas.json                                          OK
+ eip2929-ff.json                                                 OK
+ eip2929.json                                                    OK
+ eip2929OOG.json                                                 OK
+ gasCost.json                                                    OK
+ gasCostBerlin.json                                              OK
+ gasCostExp.json                                                 OK
+ gasCostJump.json                                                OK
+ gasCostMemSeg.json                                              OK
+ gasCostMemory.json                                              OK
+ gasCostReturn.json                                              OK
```
OK: 40/40 Fail: 0/40 Skip: 0/40
## stEIP1559
```diff
+ baseFeeDiffPlaces.json                                          OK
+ gasPriceDiffPlaces.json                                         OK
+ intrinsic.json                                                  OK
+ lowFeeCap.json                                                  OK
+ lowGasLimit.json                                                OK
+ lowGasPriceOldTypes.json                                        OK
+ outOfFunds.json                                                 OK
+ outOfFundsOldTypes.json                                         OK
+ senderBalance.json                                              OK
+ tipTooHigh.json                                                 OK
+ transactionIntinsicBug.json                                     OK
+ transactionIntinsicBug_Paris.json                               OK
+ typeTwoBerlin.json                                              OK
+ valCausesOOF.json                                               OK
```
OK: 14/14 Fail: 0/14 Skip: 0/14
## stEIP158Specific
```diff
+ CALL_OneVCallSuicide.json                                       OK
+ CALL_OneVCallSuicide2.json                                      OK
+ CALL_ZeroVCallSuicide.json                                      OK
+ EXP_Empty.json                                                  OK
+ EXTCODESIZE_toEpmty.json                                        OK
+ EXTCODESIZE_toEpmtyParis.json                                   OK
+ EXTCODESIZE_toNonExistent.json                                  OK
+ callToEmptyThenCallError.json                                   OK
+ callToEmptyThenCallErrorParis.json                              OK
+ vitalikTransactionTest.json                                     OK
+ vitalikTransactionTestParis.json                                OK
```
OK: 11/11 Fail: 0/11 Skip: 0/11
## stEIP2930
```diff
+ addressOpcodes.json                                             OK
+ coinbaseT01.json                                                OK
+ coinbaseT2.json                                                 OK
+ manualCreate.json                                               OK
+ storageCosts.json                                               OK
+ transactionCosts.json                                           OK
+ variedContext.json                                              OK
```
OK: 7/7 Fail: 0/7 Skip: 0/7
## stEIP3607
```diff
+ initCollidingWithNonEmptyAccount.json                           OK
+ transactionCollidingWithNonEmptyAccount_calls.json              OK
+ transactionCollidingWithNonEmptyAccount_callsItself.json        OK
+ transactionCollidingWithNonEmptyAccount_init.json               OK
+ transactionCollidingWithNonEmptyAccount_init_Paris.json         OK
+ transactionCollidingWithNonEmptyAccount_send.json               OK
+ transactionCollidingWithNonEmptyAccount_send_Paris.json         OK
```
OK: 7/7 Fail: 0/7 Skip: 0/7
## stEIP3651-warmcoinbase
```diff
+ coinbaseWarmAccountCallGas.json                                 OK
+ coinbaseWarmAccountCallGasFail.json                             OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## stEIP3855-push0
```diff
+ push0.json                                                      OK
+ push0Gas.json                                                   OK
+ push0Gas2.json                                                  OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## stEIP3860-limitmeterinitcode
```diff
+ create2InitCodeSizeLimit.json                                   OK
+ createInitCodeSizeLimit.json                                    OK
+ creationTxInitCodeSizeLimit.json                                OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## stEIP4844-blobtransactions
```diff
+ blobhashListBounds3.json                                        OK
+ blobhashListBounds4.json                                        OK
+ blobhashListBounds5.json                                        OK
+ blobhashListBounds6.json                                        OK
+ blobhashListBounds7.json                                        OK
+ createBlobhashTx.json                                           OK
+ emptyBlobhashList.json                                          OK
+ opcodeBlobhBounds.json                                          OK
+ opcodeBlobhashOutOfRange.json                                   OK
+ wrongBlobhashVersion.json                                       OK
```
OK: 10/10 Fail: 0/10 Skip: 0/10
## stEIP5656-MCOPY
```diff
+ MCOPY.json                                                      OK
+ MCOPY_copy_cost.json                                            OK
+ MCOPY_memory_expansion_cost.json                                OK
+ MCOPY_memory_hash.json                                          OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## stExample
```diff
+ accessListExample.json                                          OK
+ add11.json                                                      OK
+ add11_yml.json                                                  OK
+ basefeeExample.json                                             OK
+ eip1559.json                                                    OK
+ indexesOmitExample.json                                         OK
+ invalidTr.json                                                  OK
+ labelsExample.json                                              OK
+ mergeTest.json                                                  OK
+ rangesExample.json                                              OK
+ solidityExample.json                                            OK
+ yulExample.json                                                 OK
```
OK: 12/12 Fail: 0/12 Skip: 0/12
## stExtCodeHash
```diff
+ callToNonExistent.json                                          OK
+ callToSuicideThenExtcodehash.json                               OK
+ codeCopyZero.json                                               OK
+ codeCopyZero_Paris.json                                         OK
+ createEmptyThenExtcodehash.json                                 OK
+ dynamicAccountOverwriteEmpty.json                               OK
+ dynamicAccountOverwriteEmpty_Paris.json                         OK
+ extCodeCopyBounds.json                                          OK
+ extCodeHashAccountWithoutCode.json                              OK
+ extCodeHashCALL.json                                            OK
+ extCodeHashCALLCODE.json                                        OK
+ extCodeHashChangedAccount.json                                  OK
+ extCodeHashCreatedAndDeletedAccount.json                        OK
+ extCodeHashCreatedAndDeletedAccountCall.json                    OK
+ extCodeHashCreatedAndDeletedAccountRecheckInOuterCall.json      OK
+ extCodeHashCreatedAndDeletedAccountStaticCall.json              OK
+ extCodeHashDELEGATECALL.json                                    OK
+ extCodeHashDeletedAccount.json                                  OK
+ extCodeHashDeletedAccount1.json                                 OK
+ extCodeHashDeletedAccount1Cancun.json                           OK
+ extCodeHashDeletedAccount2.json                                 OK
+ extCodeHashDeletedAccount2Cancun.json                           OK
+ extCodeHashDeletedAccount3.json                                 OK
+ extCodeHashDeletedAccount4.json                                 OK
+ extCodeHashDeletedAccountCancun.json                            OK
+ extCodeHashDynamicArgument.json                                 OK
+ extCodeHashInInitCode.json                                      OK
+ extCodeHashMaxCodeSize.json                                     OK
+ extCodeHashNewAccount.json                                      OK
+ extCodeHashNonExistingAccount.json                              OK
+ extCodeHashPrecompiles.json                                     OK
+ extCodeHashSTATICCALL.json                                      OK
+ extCodeHashSelf.json                                            OK
+ extCodeHashSelfInInit.json                                      OK
+ extCodeHashSubcallOOG.json                                      OK
+ extCodeHashSubcallSuicide.json                                  OK
+ extCodeHashSubcallSuicideCancun.json                            OK
+ extcodehashEmpty.json                                           OK
+ extcodehashEmpty_Paris.json                                     OK
```
OK: 39/39 Fail: 0/39 Skip: 0/39
## stHomesteadSpecific
```diff
+ contractCreationOOGdontLeaveEmptyContract.json                  OK
+ contractCreationOOGdontLeaveEmptyContractViaTransaction.json    OK
+ createContractViaContract.json                                  OK
+ createContractViaContractOOGInitCode.json                       OK
+ createContractViaTransactionCost53000.json                      OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## stInitCodeTest
```diff
+ CallContractToCreateContractAndCallItOOG.json                   OK
+ CallContractToCreateContractNoCash.json                         OK
+ CallContractToCreateContractOOG.json                            OK
+ CallContractToCreateContractOOGBonusGas.json                    OK
+ CallContractToCreateContractWhichWouldCreateContractIfCalled.js OK
+ CallContractToCreateContractWhichWouldCreateContractInInitCode. OK
+ CallRecursiveContract.json                                      OK
+ CallTheContractToCreateEmptyContract.json                       OK
+ OutOfGasContractCreation.json                                   OK
+ OutOfGasPrefundedContractCreation.json                          OK
+ ReturnTest.json                                                 OK
+ ReturnTest2.json                                                OK
+ StackUnderFlowContractCreation.json                             OK
+ TransactionCreateAutoSuicideContract.json                       OK
+ TransactionCreateRandomInitCode.json                            OK
+ TransactionCreateStopInInitcode.json                            OK
+ TransactionCreateSuicideInInitcode.json                         OK
```
OK: 17/17 Fail: 0/17 Skip: 0/17
## stLogTests
```diff
+ log0_emptyMem.json                                              OK
+ log0_logMemStartTooHigh.json                                    OK
+ log0_logMemsizeTooHigh.json                                     OK
+ log0_logMemsizeZero.json                                        OK
+ log0_nonEmptyMem.json                                           OK
+ log0_nonEmptyMem_logMemSize1.json                               OK
+ log0_nonEmptyMem_logMemSize1_logMemStart31.json                 OK
+ log1_Caller.json                                                OK
+ log1_MaxTopic.json                                              OK
+ log1_emptyMem.json                                              OK
+ log1_logMemStartTooHigh.json                                    OK
+ log1_logMemsizeTooHigh.json                                     OK
+ log1_logMemsizeZero.json                                        OK
+ log1_nonEmptyMem.json                                           OK
+ log1_nonEmptyMem_logMemSize1.json                               OK
+ log1_nonEmptyMem_logMemSize1_logMemStart31.json                 OK
+ log2_Caller.json                                                OK
+ log2_MaxTopic.json                                              OK
+ log2_emptyMem.json                                              OK
+ log2_logMemStartTooHigh.json                                    OK
+ log2_logMemsizeTooHigh.json                                     OK
+ log2_logMemsizeZero.json                                        OK
+ log2_nonEmptyMem.json                                           OK
+ log2_nonEmptyMem_logMemSize1.json                               OK
+ log2_nonEmptyMem_logMemSize1_logMemStart31.json                 OK
+ log3_Caller.json                                                OK
+ log3_MaxTopic.json                                              OK
+ log3_PC.json                                                    OK
+ log3_emptyMem.json                                              OK
+ log3_logMemStartTooHigh.json                                    OK
+ log3_logMemsizeTooHigh.json                                     OK
+ log3_logMemsizeZero.json                                        OK
+ log3_nonEmptyMem.json                                           OK
+ log3_nonEmptyMem_logMemSize1.json                               OK
+ log3_nonEmptyMem_logMemSize1_logMemStart31.json                 OK
+ log4_Caller.json                                                OK
+ log4_MaxTopic.json                                              OK
+ log4_PC.json                                                    OK
+ log4_emptyMem.json                                              OK
+ log4_logMemStartTooHigh.json                                    OK
+ log4_logMemsizeTooHigh.json                                     OK
+ log4_logMemsizeZero.json                                        OK
+ log4_nonEmptyMem.json                                           OK
+ log4_nonEmptyMem_logMemSize1.json                               OK
+ log4_nonEmptyMem_logMemSize1_logMemStart31.json                 OK
+ logInOOG_Call.json                                              OK
```
OK: 46/46 Fail: 0/46 Skip: 0/46
## stMemExpandingEIP150Calls
```diff
+ CallAndCallcodeConsumeMoreGasThenTransactionHasWithMemExpanding OK
+ CallAskMoreGasOnDepth2ThenTransactionHasWithMemExpandingCalls.j OK
+ CallGoesOOGOnSecondLevel2WithMemExpandingCalls.json             OK
+ CallGoesOOGOnSecondLevelWithMemExpandingCalls.json              OK
+ CreateAndGasInsideCreateWithMemExpandingCalls.json              OK
+ DelegateCallOnEIPWithMemExpandingCalls.json                     OK
+ ExecuteCallThatAskMoreGasThenTransactionHasWithMemExpandingCall OK
+ NewGasPriceForCodesWithMemExpandingCalls.json                   OK
+ OOGinReturn.json                                                OK
```
OK: 9/9 Fail: 0/9 Skip: 0/9
## stMemoryStressTest
```diff
  CALLCODE_Bounds.json                                            Skip
  CALLCODE_Bounds2.json                                           Skip
  CALLCODE_Bounds3.json                                           Skip
  CALLCODE_Bounds4.json                                           Skip
  CALL_Bounds.json                                                Skip
  CALL_Bounds2.json                                               Skip
  CALL_Bounds2a.json                                              Skip
  CALL_Bounds3.json                                               Skip
+ CREATE_Bounds.json                                              OK
+ CREATE_Bounds2.json                                             OK
+ CREATE_Bounds3.json                                             OK
  DELEGATECALL_Bounds.json                                        Skip
  DELEGATECALL_Bounds2.json                                       Skip
  DELEGATECALL_Bounds3.json                                       Skip
+ DUP_Bounds.json                                                 OK
+ FillStack.json                                                  OK
+ JUMPI_Bounds.json                                               OK
+ JUMP_Bounds.json                                                OK
+ JUMP_Bounds2.json                                               OK
+ MLOAD_Bounds.json                                               OK
+ MLOAD_Bounds2.json                                              OK
+ MLOAD_Bounds3.json                                              OK
+ MSTORE_Bounds.json                                              OK
+ MSTORE_Bounds2.json                                             OK
+ MSTORE_Bounds2a.json                                            OK
+ POP_Bounds.json                                                 OK
+ RETURN_Bounds.json                                              OK
+ SLOAD_Bounds.json                                               OK
+ SSTORE_Bounds.json                                              OK
+ mload32bitBound.json                                            OK
+ mload32bitBound2.json                                           OK
+ mload32bitBound_Msize.json                                      OK
+ mload32bitBound_return.json                                     OK
+ mload32bitBound_return2.json                                    OK
+ static_CALL_Bounds.json                                         OK
+ static_CALL_Bounds2.json                                        OK
+ static_CALL_Bounds2a.json                                       OK
+ static_CALL_Bounds3.json                                        OK
```
OK: 27/38 Fail: 0/38 Skip: 11/38
## stMemoryTest
```diff
+ buffer.json                                                     OK
+ bufferSrcOffset.json                                            OK
+ callDataCopyOffset.json                                         OK
+ calldatacopy_dejavu.json                                        OK
+ calldatacopy_dejavu2.json                                       OK
+ codeCopyOffset.json                                             OK
+ codecopy_dejavu.json                                            OK
+ codecopy_dejavu2.json                                           OK
+ extcodecopy_dejavu.json                                         OK
+ log1_dejavu.json                                                OK
+ log2_dejavu.json                                                OK
+ log3_dejavu.json                                                OK
+ log4_dejavu.json                                                OK
+ mem0b_singleByte.json                                           OK
+ mem31b_singleByte.json                                          OK
+ mem32b_singleByte.json                                          OK
+ mem32kb+1.json                                                  OK
+ mem32kb+31.json                                                 OK
+ mem32kb+32.json                                                 OK
+ mem32kb+33.json                                                 OK
+ mem32kb-1.json                                                  OK
+ mem32kb-31.json                                                 OK
+ mem32kb-32.json                                                 OK
+ mem32kb-33.json                                                 OK
+ mem32kb.json                                                    OK
+ mem32kb_singleByte+1.json                                       OK
+ mem32kb_singleByte+31.json                                      OK
+ mem32kb_singleByte+32.json                                      OK
+ mem32kb_singleByte+33.json                                      OK
+ mem32kb_singleByte-1.json                                       OK
+ mem32kb_singleByte-31.json                                      OK
+ mem32kb_singleByte-32.json                                      OK
+ mem32kb_singleByte-33.json                                      OK
+ mem32kb_singleByte.json                                         OK
+ mem33b_singleByte.json                                          OK
+ mem64kb+1.json                                                  OK
+ mem64kb+31.json                                                 OK
+ mem64kb+32.json                                                 OK
+ mem64kb+33.json                                                 OK
+ mem64kb-1.json                                                  OK
+ mem64kb-31.json                                                 OK
+ mem64kb-32.json                                                 OK
+ mem64kb-33.json                                                 OK
+ mem64kb.json                                                    OK
+ mem64kb_singleByte+1.json                                       OK
+ mem64kb_singleByte+31.json                                      OK
+ mem64kb_singleByte+32.json                                      OK
+ mem64kb_singleByte+33.json                                      OK
+ mem64kb_singleByte-1.json                                       OK
+ mem64kb_singleByte-31.json                                      OK
+ mem64kb_singleByte-32.json                                      OK
+ mem64kb_singleByte-33.json                                      OK
+ mem64kb_singleByte.json                                         OK
+ memCopySelf.json                                                OK
+ memReturn.json                                                  OK
+ mload16bitBound.json                                            OK
+ mload8bitBound.json                                             OK
+ mload_dejavu.json                                               OK
+ mstore_dejavu.json                                              OK
+ mstroe8_dejavu.json                                             OK
+ oog.json                                                        OK
+ sha3_dejavu.json                                                OK
+ stackLimitGas_1023.json                                         OK
+ stackLimitGas_1024.json                                         OK
+ stackLimitGas_1025.json                                         OK
+ stackLimitPush31_1023.json                                      OK
+ stackLimitPush31_1024.json                                      OK
+ stackLimitPush31_1025.json                                      OK
+ stackLimitPush32_1023.json                                      OK
+ stackLimitPush32_1024.json                                      OK
+ stackLimitPush32_1025.json                                      OK
```
OK: 71/71 Fail: 0/71 Skip: 0/71
## stNonZeroCallsTest
```diff
+ NonZeroValue_CALL.json                                          OK
+ NonZeroValue_CALLCODE.json                                      OK
+ NonZeroValue_CALLCODE_ToEmpty.json                              OK
+ NonZeroValue_CALLCODE_ToEmpty_Paris.json                        OK
+ NonZeroValue_CALLCODE_ToNonNonZeroBalance.json                  OK
+ NonZeroValue_CALLCODE_ToOneStorageKey.json                      OK
+ NonZeroValue_CALLCODE_ToOneStorageKey_Paris.json                OK
+ NonZeroValue_CALL_ToEmpty.json                                  OK
+ NonZeroValue_CALL_ToEmpty_Paris.json                            OK
+ NonZeroValue_CALL_ToNonNonZeroBalance.json                      OK
+ NonZeroValue_CALL_ToOneStorageKey.json                          OK
+ NonZeroValue_CALL_ToOneStorageKey_Paris.json                    OK
+ NonZeroValue_DELEGATECALL.json                                  OK
+ NonZeroValue_DELEGATECALL_ToEmpty.json                          OK
+ NonZeroValue_DELEGATECALL_ToEmpty_Paris.json                    OK
+ NonZeroValue_DELEGATECALL_ToNonNonZeroBalance.json              OK
+ NonZeroValue_DELEGATECALL_ToOneStorageKey.json                  OK
+ NonZeroValue_DELEGATECALL_ToOneStorageKey_Paris.json            OK
+ NonZeroValue_SUICIDE.json                                       OK
+ NonZeroValue_SUICIDE_ToEmpty.json                               OK
+ NonZeroValue_SUICIDE_ToEmpty_Paris.json                         OK
+ NonZeroValue_SUICIDE_ToNonNonZeroBalance.json                   OK
+ NonZeroValue_SUICIDE_ToOneStorageKey.json                       OK
+ NonZeroValue_SUICIDE_ToOneStorageKey_Paris.json                 OK
+ NonZeroValue_TransactionCALL.json                               OK
+ NonZeroValue_TransactionCALL_ToEmpty.json                       OK
+ NonZeroValue_TransactionCALL_ToEmpty_Paris.json                 OK
+ NonZeroValue_TransactionCALL_ToNonNonZeroBalance.json           OK
+ NonZeroValue_TransactionCALL_ToOneStorageKey.json               OK
+ NonZeroValue_TransactionCALL_ToOneStorageKey_Paris.json         OK
+ NonZeroValue_TransactionCALLwithData.json                       OK
+ NonZeroValue_TransactionCALLwithData_ToEmpty.json               OK
+ NonZeroValue_TransactionCALLwithData_ToEmpty_Paris.json         OK
+ NonZeroValue_TransactionCALLwithData_ToNonNonZeroBalance.json   OK
+ NonZeroValue_TransactionCALLwithData_ToOneStorageKey.json       OK
+ NonZeroValue_TransactionCALLwithData_ToOneStorageKey_Paris.json OK
```
OK: 36/36 Fail: 0/36 Skip: 0/36
## stPreCompiledContracts
```diff
+ blake2B.json                                                    OK
+ delegatecall09Undefined.json                                    OK
+ idPrecomps.json                                                 OK
+ identity_to_bigger.json                                         OK
+ identity_to_smaller.json                                        OK
+ modexp.json                                                     OK
+ modexpTests.json                                                OK
+ precompsEIP2929.json                                            OK
+ precompsEIP2929Cancun.json                                      OK
+ sec80.json                                                      OK
```
OK: 10/10 Fail: 0/10 Skip: 0/10
## stPreCompiledContracts2
```diff
+ CALLBlake2f.json                                                OK
+ CALLCODEBlake2f.json                                            OK
+ CALLCODEEcrecover0.json                                         OK
+ CALLCODEEcrecover0_0input.json                                  OK
+ CALLCODEEcrecover0_Gas2999.json                                 OK
+ CALLCODEEcrecover0_NoGas.json                                   OK
+ CALLCODEEcrecover0_completeReturnValue.json                     OK
+ CALLCODEEcrecover0_gas3000.json                                 OK
+ CALLCODEEcrecover0_overlappingInputOutput.json                  OK
+ CALLCODEEcrecover1.json                                         OK
+ CALLCODEEcrecover2.json                                         OK
+ CALLCODEEcrecover3.json                                         OK
+ CALLCODEEcrecover80.json                                        OK
+ CALLCODEEcrecoverH_prefixed0.json                               OK
+ CALLCODEEcrecoverR_prefixed0.json                               OK
+ CALLCODEEcrecoverS_prefixed0.json                               OK
+ CALLCODEEcrecoverV_prefixed0.json                               OK
+ CALLCODEEcrecoverV_prefixedf0.json                              OK
+ CALLCODEIdentitiy_0.json                                        OK
+ CALLCODEIdentitiy_1.json                                        OK
+ CALLCODEIdentity_1_nonzeroValue.json                            OK
+ CALLCODEIdentity_2.json                                         OK
+ CALLCODEIdentity_3.json                                         OK
+ CALLCODEIdentity_4.json                                         OK
+ CALLCODEIdentity_4_gas17.json                                   OK
+ CALLCODEIdentity_4_gas18.json                                   OK
+ CALLCODEIdentity_5.json                                         OK
+ CALLCODERipemd160_0.json                                        OK
+ CALLCODERipemd160_1.json                                        OK
+ CALLCODERipemd160_2.json                                        OK
+ CALLCODERipemd160_3.json                                        OK
+ CALLCODERipemd160_3_postfixed0.json                             OK
+ CALLCODERipemd160_3_prefixed0.json                              OK
+ CALLCODERipemd160_4.json                                        OK
+ CALLCODERipemd160_4_gas719.json                                 OK
+ CALLCODERipemd160_5.json                                        OK
+ CALLCODESha256_0.json                                           OK
+ CALLCODESha256_1.json                                           OK
+ CALLCODESha256_1_nonzeroValue.json                              OK
+ CALLCODESha256_2.json                                           OK
+ CALLCODESha256_3.json                                           OK
+ CALLCODESha256_3_postfix0.json                                  OK
+ CALLCODESha256_3_prefix0.json                                   OK
+ CALLCODESha256_4.json                                           OK
+ CALLCODESha256_4_gas99.json                                     OK
+ CALLCODESha256_5.json                                           OK
+ CallEcrecover0.json                                             OK
+ CallEcrecover0_0input.json                                      OK
+ CallEcrecover0_Gas2999.json                                     OK
+ CallEcrecover0_NoGas.json                                       OK
+ CallEcrecover0_completeReturnValue.json                         OK
+ CallEcrecover0_gas3000.json                                     OK
+ CallEcrecover0_overlappingInputOutput.json                      OK
+ CallEcrecover1.json                                             OK
+ CallEcrecover2.json                                             OK
+ CallEcrecover3.json                                             OK
+ CallEcrecover80.json                                            OK
+ CallEcrecoverCheckLength.json                                   OK
+ CallEcrecoverCheckLengthWrongV.json                             OK
+ CallEcrecoverH_prefixed0.json                                   OK
+ CallEcrecoverInvalidSignature.json                              OK
+ CallEcrecoverR_prefixed0.json                                   OK
+ CallEcrecoverS_prefixed0.json                                   OK
+ CallEcrecoverUnrecoverableKey.json                              OK
+ CallEcrecoverV_prefixed0.json                                   OK
+ CallEcrecover_Overflow.json                                     OK
+ CallIdentitiy_0.json                                            OK
+ CallIdentitiy_1.json                                            OK
+ CallIdentity_1_nonzeroValue.json                                OK
+ CallIdentity_2.json                                             OK
+ CallIdentity_3.json                                             OK
+ CallIdentity_4.json                                             OK
+ CallIdentity_4_gas17.json                                       OK
+ CallIdentity_4_gas18.json                                       OK
+ CallIdentity_5.json                                             OK
+ CallIdentity_6_inputShorterThanOutput.json                      OK
+ CallRipemd160_0.json                                            OK
+ CallRipemd160_1.json                                            OK
+ CallRipemd160_2.json                                            OK
+ CallRipemd160_3.json                                            OK
+ CallRipemd160_3_postfixed0.json                                 OK
+ CallRipemd160_3_prefixed0.json                                  OK
+ CallRipemd160_4.json                                            OK
+ CallRipemd160_4_gas719.json                                     OK
+ CallRipemd160_5.json                                            OK
+ CallSha256_0.json                                               OK
+ CallSha256_1.json                                               OK
+ CallSha256_1_nonzeroValue.json                                  OK
+ CallSha256_2.json                                               OK
+ CallSha256_3.json                                               OK
+ CallSha256_3_postfix0.json                                      OK
+ CallSha256_3_prefix0.json                                       OK
+ CallSha256_4.json                                               OK
+ CallSha256_4_gas99.json                                         OK
+ CallSha256_5.json                                               OK
+ ecrecoverShortBuff.json                                         OK
+ ecrecoverWeirdV.json                                            OK
+ modexpRandomInput.json                                          OK
+ modexp_0_0_0_20500.json                                         OK
+ modexp_0_0_0_22000.json                                         OK
+ modexp_0_0_0_25000.json                                         OK
+ modexp_0_0_0_35000.json                                         OK
```
OK: 102/102 Fail: 0/102 Skip: 0/102
## stQuadraticComplexityTest
```diff
  Call1MB1024Calldepth.json                                       Skip
  Call20KbytesContract50_1.json                                   Skip
  Call20KbytesContract50_2.json                                   Skip
  Call20KbytesContract50_3.json                                   Skip
  Call50000.json                                                  Skip
  Call50000_ecrec.json                                            Skip
  Call50000_identity.json                                         Skip
  Call50000_identity2.json                                        Skip
  Call50000_rip160.json                                           Skip
  Call50000_sha256.json                                           Skip
  Callcode50000.json                                              Skip
  Create1000.json                                                 Skip
  Create1000Byzantium.json                                        Skip
  Create1000Shnghai.json                                          Skip
  QuadraticComplexitySolidity_CallDataCopy.json                   Skip
  Return50000.json                                                Skip
  Return50000_2.json                                              Skip
```
OK: 0/17 Fail: 0/17 Skip: 17/17
## stRandom
```diff
+ randomStatetest0.json                                           OK
  randomStatetest1.json                                           Skip
+ randomStatetest10.json                                          OK
+ randomStatetest100.json                                         OK
+ randomStatetest102.json                                         OK
+ randomStatetest103.json                                         OK
+ randomStatetest104.json                                         OK
+ randomStatetest105.json                                         OK
+ randomStatetest106.json                                         OK
+ randomStatetest107.json                                         OK
+ randomStatetest108.json                                         OK
+ randomStatetest11.json                                          OK
+ randomStatetest110.json                                         OK
+ randomStatetest111.json                                         OK
+ randomStatetest112.json                                         OK
+ randomStatetest114.json                                         OK
+ randomStatetest115.json                                         OK
+ randomStatetest116.json                                         OK
+ randomStatetest117.json                                         OK
+ randomStatetest118.json                                         OK
+ randomStatetest119.json                                         OK
+ randomStatetest12.json                                          OK
+ randomStatetest120.json                                         OK
+ randomStatetest121.json                                         OK
+ randomStatetest122.json                                         OK
+ randomStatetest124.json                                         OK
+ randomStatetest125.json                                         OK
+ randomStatetest126.json                                         OK
+ randomStatetest129.json                                         OK
+ randomStatetest13.json                                          OK
+ randomStatetest130.json                                         OK
+ randomStatetest131.json                                         OK
+ randomStatetest133.json                                         OK
+ randomStatetest134.json                                         OK
+ randomStatetest135.json                                         OK
+ randomStatetest137.json                                         OK
+ randomStatetest138.json                                         OK
+ randomStatetest139.json                                         OK
+ randomStatetest14.json                                          OK
+ randomStatetest142.json                                         OK
+ randomStatetest143.json                                         OK
+ randomStatetest144.json                                         OK
+ randomStatetest145.json                                         OK
+ randomStatetest146.json                                         OK
+ randomStatetest147.json                                         OK
+ randomStatetest148.json                                         OK
+ randomStatetest149.json                                         OK
+ randomStatetest15.json                                          OK
+ randomStatetest150.json                                         OK
+ randomStatetest151.json                                         OK
+ randomStatetest153.json                                         OK
+ randomStatetest154.json                                         OK
+ randomStatetest155.json                                         OK
+ randomStatetest156.json                                         OK
+ randomStatetest157.json                                         OK
+ randomStatetest158.json                                         OK
+ randomStatetest159.json                                         OK
+ randomStatetest16.json                                          OK
+ randomStatetest161.json                                         OK
+ randomStatetest162.json                                         OK
+ randomStatetest163.json                                         OK
+ randomStatetest164.json                                         OK
+ randomStatetest166.json                                         OK
+ randomStatetest167.json                                         OK
+ randomStatetest169.json                                         OK
+ randomStatetest17.json                                          OK
+ randomStatetest171.json                                         OK
+ randomStatetest172.json                                         OK
+ randomStatetest173.json                                         OK
+ randomStatetest174.json                                         OK
+ randomStatetest175.json                                         OK
+ randomStatetest176.json                                         OK
+ randomStatetest177.json                                         OK
+ randomStatetest178.json                                         OK
+ randomStatetest179.json                                         OK
+ randomStatetest18.json                                          OK
+ randomStatetest180.json                                         OK
+ randomStatetest183.json                                         OK
+ randomStatetest184.json                                         OK
+ randomStatetest185.json                                         OK
+ randomStatetest187.json                                         OK
+ randomStatetest188.json                                         OK
+ randomStatetest189.json                                         OK
+ randomStatetest19.json                                          OK
+ randomStatetest190.json                                         OK
+ randomStatetest191.json                                         OK
+ randomStatetest192.json                                         OK
+ randomStatetest194.json                                         OK
+ randomStatetest195.json                                         OK
+ randomStatetest196.json                                         OK
+ randomStatetest197.json                                         OK
+ randomStatetest198.json                                         OK
+ randomStatetest199.json                                         OK
+ randomStatetest2.json                                           OK
+ randomStatetest20.json                                          OK
+ randomStatetest200.json                                         OK
+ randomStatetest201.json                                         OK
+ randomStatetest202.json                                         OK
+ randomStatetest204.json                                         OK
+ randomStatetest205.json                                         OK
+ randomStatetest206.json                                         OK
+ randomStatetest207.json                                         OK
+ randomStatetest208.json                                         OK
+ randomStatetest209.json                                         OK
+ randomStatetest210.json                                         OK
+ randomStatetest211.json                                         OK
+ randomStatetest212.json                                         OK
+ randomStatetest214.json                                         OK
+ randomStatetest215.json                                         OK
+ randomStatetest216.json                                         OK
+ randomStatetest217.json                                         OK
+ randomStatetest219.json                                         OK
+ randomStatetest22.json                                          OK
+ randomStatetest220.json                                         OK
+ randomStatetest221.json                                         OK
+ randomStatetest222.json                                         OK
+ randomStatetest225.json                                         OK
+ randomStatetest226.json                                         OK
+ randomStatetest227.json                                         OK
+ randomStatetest228.json                                         OK
+ randomStatetest23.json                                          OK
+ randomStatetest230.json                                         OK
+ randomStatetest231.json                                         OK
+ randomStatetest232.json                                         OK
+ randomStatetest233.json                                         OK
+ randomStatetest236.json                                         OK
+ randomStatetest237.json                                         OK
+ randomStatetest238.json                                         OK
+ randomStatetest24.json                                          OK
+ randomStatetest242.json                                         OK
+ randomStatetest243.json                                         OK
+ randomStatetest244.json                                         OK
+ randomStatetest245.json                                         OK
+ randomStatetest246.json                                         OK
+ randomStatetest247.json                                         OK
+ randomStatetest248.json                                         OK
+ randomStatetest249.json                                         OK
+ randomStatetest25.json                                          OK
+ randomStatetest250.json                                         OK
+ randomStatetest251.json                                         OK
+ randomStatetest252.json                                         OK
+ randomStatetest254.json                                         OK
+ randomStatetest257.json                                         OK
+ randomStatetest259.json                                         OK
+ randomStatetest26.json                                          OK
+ randomStatetest260.json                                         OK
+ randomStatetest261.json                                         OK
+ randomStatetest263.json                                         OK
+ randomStatetest264.json                                         OK
+ randomStatetest265.json                                         OK
+ randomStatetest266.json                                         OK
+ randomStatetest267.json                                         OK
+ randomStatetest268.json                                         OK
+ randomStatetest269.json                                         OK
+ randomStatetest27.json                                          OK
+ randomStatetest270.json                                         OK
+ randomStatetest271.json                                         OK
+ randomStatetest273.json                                         OK
+ randomStatetest274.json                                         OK
+ randomStatetest275.json                                         OK
+ randomStatetest276.json                                         OK
+ randomStatetest278.json                                         OK
+ randomStatetest279.json                                         OK
+ randomStatetest28.json                                          OK
+ randomStatetest280.json                                         OK
+ randomStatetest281.json                                         OK
+ randomStatetest282.json                                         OK
+ randomStatetest283.json                                         OK
+ randomStatetest285.json                                         OK
+ randomStatetest286.json                                         OK
+ randomStatetest287.json                                         OK
+ randomStatetest288.json                                         OK
+ randomStatetest29.json                                          OK
+ randomStatetest290.json                                         OK
+ randomStatetest291.json                                         OK
+ randomStatetest292.json                                         OK
+ randomStatetest293.json                                         OK
+ randomStatetest294.json                                         OK
+ randomStatetest295.json                                         OK
+ randomStatetest296.json                                         OK
+ randomStatetest297.json                                         OK
+ randomStatetest298.json                                         OK
+ randomStatetest299.json                                         OK
+ randomStatetest3.json                                           OK
+ randomStatetest30.json                                          OK
+ randomStatetest300.json                                         OK
+ randomStatetest301.json                                         OK
+ randomStatetest302.json                                         OK
+ randomStatetest303.json                                         OK
+ randomStatetest304.json                                         OK
+ randomStatetest305.json                                         OK
+ randomStatetest306.json                                         OK
+ randomStatetest307.json                                         OK
+ randomStatetest308.json                                         OK
+ randomStatetest309.json                                         OK
+ randomStatetest31.json                                          OK
+ randomStatetest310.json                                         OK
+ randomStatetest311.json                                         OK
+ randomStatetest312.json                                         OK
+ randomStatetest313.json                                         OK
+ randomStatetest315.json                                         OK
+ randomStatetest316.json                                         OK
+ randomStatetest318.json                                         OK
+ randomStatetest320.json                                         OK
+ randomStatetest321.json                                         OK
+ randomStatetest322.json                                         OK
+ randomStatetest323.json                                         OK
+ randomStatetest325.json                                         OK
+ randomStatetest326.json                                         OK
+ randomStatetest327.json                                         OK
+ randomStatetest329.json                                         OK
+ randomStatetest33.json                                          OK
+ randomStatetest332.json                                         OK
+ randomStatetest333.json                                         OK
+ randomStatetest334.json                                         OK
+ randomStatetest335.json                                         OK
+ randomStatetest336.json                                         OK
+ randomStatetest337.json                                         OK
+ randomStatetest338.json                                         OK
+ randomStatetest339.json                                         OK
+ randomStatetest340.json                                         OK
+ randomStatetest341.json                                         OK
+ randomStatetest342.json                                         OK
+ randomStatetest343.json                                         OK
+ randomStatetest345.json                                         OK
+ randomStatetest346.json                                         OK
  randomStatetest347.json                                         Skip
+ randomStatetest348.json                                         OK
+ randomStatetest349.json                                         OK
+ randomStatetest350.json                                         OK
+ randomStatetest351.json                                         OK
  randomStatetest352.json                                         Skip
+ randomStatetest353.json                                         OK
+ randomStatetest354.json                                         OK
+ randomStatetest355.json                                         OK
+ randomStatetest356.json                                         OK
+ randomStatetest357.json                                         OK
+ randomStatetest358.json                                         OK
+ randomStatetest359.json                                         OK
+ randomStatetest36.json                                          OK
+ randomStatetest360.json                                         OK
+ randomStatetest361.json                                         OK
+ randomStatetest362.json                                         OK
+ randomStatetest363.json                                         OK
+ randomStatetest364.json                                         OK
+ randomStatetest365.json                                         OK
+ randomStatetest366.json                                         OK
+ randomStatetest367.json                                         OK
+ randomStatetest368.json                                         OK
+ randomStatetest369.json                                         OK
+ randomStatetest37.json                                          OK
+ randomStatetest370.json                                         OK
+ randomStatetest371.json                                         OK
+ randomStatetest372.json                                         OK
+ randomStatetest376.json                                         OK
+ randomStatetest378.json                                         OK
+ randomStatetest379.json                                         OK
+ randomStatetest380.json                                         OK
+ randomStatetest381.json                                         OK
+ randomStatetest382.json                                         OK
+ randomStatetest383.json                                         OK
+ randomStatetest384.json                                         OK
+ randomStatetest39.json                                          OK
+ randomStatetest4.json                                           OK
+ randomStatetest41.json                                          OK
+ randomStatetest42.json                                          OK
+ randomStatetest43.json                                          OK
+ randomStatetest45.json                                          OK
+ randomStatetest47.json                                          OK
+ randomStatetest48.json                                          OK
+ randomStatetest49.json                                          OK
+ randomStatetest5.json                                           OK
+ randomStatetest51.json                                          OK
+ randomStatetest52.json                                          OK
+ randomStatetest53.json                                          OK
+ randomStatetest54.json                                          OK
+ randomStatetest55.json                                          OK
+ randomStatetest57.json                                          OK
+ randomStatetest58.json                                          OK
+ randomStatetest59.json                                          OK
+ randomStatetest6.json                                           OK
+ randomStatetest60.json                                          OK
+ randomStatetest62.json                                          OK
+ randomStatetest63.json                                          OK
+ randomStatetest64.json                                          OK
+ randomStatetest66.json                                          OK
+ randomStatetest67.json                                          OK
+ randomStatetest69.json                                          OK
+ randomStatetest72.json                                          OK
+ randomStatetest73.json                                          OK
+ randomStatetest74.json                                          OK
+ randomStatetest75.json                                          OK
+ randomStatetest77.json                                          OK
+ randomStatetest78.json                                          OK
+ randomStatetest80.json                                          OK
+ randomStatetest81.json                                          OK
+ randomStatetest82.json                                          OK
+ randomStatetest83.json                                          OK
+ randomStatetest84.json                                          OK
+ randomStatetest85.json                                          OK
+ randomStatetest87.json                                          OK
+ randomStatetest88.json                                          OK
+ randomStatetest89.json                                          OK
+ randomStatetest9.json                                           OK
+ randomStatetest90.json                                          OK
+ randomStatetest92.json                                          OK
+ randomStatetest95.json                                          OK
+ randomStatetest96.json                                          OK
+ randomStatetest97.json                                          OK
+ randomStatetest98.json                                          OK
```
OK: 307/310 Fail: 0/310 Skip: 3/310
## stRandom2
```diff
+ randomStatetest.json                                            OK
+ randomStatetest384.json                                         OK
+ randomStatetest385.json                                         OK
+ randomStatetest386.json                                         OK
+ randomStatetest387.json                                         OK
+ randomStatetest388.json                                         OK
+ randomStatetest389.json                                         OK
  randomStatetest393.json                                         Skip
+ randomStatetest395.json                                         OK
+ randomStatetest396.json                                         OK
+ randomStatetest397.json                                         OK
+ randomStatetest398.json                                         OK
+ randomStatetest399.json                                         OK
+ randomStatetest401.json                                         OK
+ randomStatetest402.json                                         OK
+ randomStatetest404.json                                         OK
+ randomStatetest405.json                                         OK
+ randomStatetest406.json                                         OK
+ randomStatetest407.json                                         OK
+ randomStatetest408.json                                         OK
+ randomStatetest409.json                                         OK
+ randomStatetest410.json                                         OK
+ randomStatetest411.json                                         OK
+ randomStatetest412.json                                         OK
+ randomStatetest413.json                                         OK
+ randomStatetest414.json                                         OK
+ randomStatetest415.json                                         OK
+ randomStatetest416.json                                         OK
+ randomStatetest417.json                                         OK
+ randomStatetest418.json                                         OK
+ randomStatetest419.json                                         OK
+ randomStatetest420.json                                         OK
+ randomStatetest421.json                                         OK
+ randomStatetest422.json                                         OK
+ randomStatetest424.json                                         OK
+ randomStatetest425.json                                         OK
+ randomStatetest426.json                                         OK
+ randomStatetest428.json                                         OK
+ randomStatetest429.json                                         OK
+ randomStatetest430.json                                         OK
+ randomStatetest433.json                                         OK
+ randomStatetest435.json                                         OK
+ randomStatetest436.json                                         OK
+ randomStatetest437.json                                         OK
+ randomStatetest438.json                                         OK
+ randomStatetest439.json                                         OK
+ randomStatetest440.json                                         OK
+ randomStatetest442.json                                         OK
+ randomStatetest443.json                                         OK
+ randomStatetest444.json                                         OK
+ randomStatetest445.json                                         OK
+ randomStatetest446.json                                         OK
+ randomStatetest447.json                                         OK
+ randomStatetest448.json                                         OK
+ randomStatetest449.json                                         OK
+ randomStatetest450.json                                         OK
+ randomStatetest451.json                                         OK
+ randomStatetest452.json                                         OK
+ randomStatetest454.json                                         OK
+ randomStatetest455.json                                         OK
+ randomStatetest456.json                                         OK
+ randomStatetest457.json                                         OK
+ randomStatetest458.json                                         OK
+ randomStatetest460.json                                         OK
+ randomStatetest461.json                                         OK
+ randomStatetest462.json                                         OK
+ randomStatetest464.json                                         OK
+ randomStatetest465.json                                         OK
+ randomStatetest466.json                                         OK
+ randomStatetest467.json                                         OK
+ randomStatetest469.json                                         OK
+ randomStatetest470.json                                         OK
+ randomStatetest471.json                                         OK
+ randomStatetest472.json                                         OK
+ randomStatetest473.json                                         OK
+ randomStatetest474.json                                         OK
+ randomStatetest475.json                                         OK
+ randomStatetest476.json                                         OK
+ randomStatetest477.json                                         OK
+ randomStatetest478.json                                         OK
+ randomStatetest480.json                                         OK
+ randomStatetest481.json                                         OK
+ randomStatetest482.json                                         OK
+ randomStatetest483.json                                         OK
+ randomStatetest484.json                                         OK
+ randomStatetest485.json                                         OK
+ randomStatetest487.json                                         OK
+ randomStatetest488.json                                         OK
+ randomStatetest489.json                                         OK
+ randomStatetest491.json                                         OK
+ randomStatetest493.json                                         OK
+ randomStatetest494.json                                         OK
+ randomStatetest495.json                                         OK
+ randomStatetest496.json                                         OK
+ randomStatetest497.json                                         OK
+ randomStatetest498.json                                         OK
+ randomStatetest499.json                                         OK
+ randomStatetest500.json                                         OK
+ randomStatetest501.json                                         OK
+ randomStatetest502.json                                         OK
+ randomStatetest503.json                                         OK
+ randomStatetest504.json                                         OK
+ randomStatetest505.json                                         OK
+ randomStatetest506.json                                         OK
+ randomStatetest507.json                                         OK
+ randomStatetest508.json                                         OK
+ randomStatetest509.json                                         OK
+ randomStatetest510.json                                         OK
+ randomStatetest511.json                                         OK
+ randomStatetest512.json                                         OK
+ randomStatetest513.json                                         OK
+ randomStatetest514.json                                         OK
+ randomStatetest516.json                                         OK
+ randomStatetest517.json                                         OK
+ randomStatetest518.json                                         OK
+ randomStatetest519.json                                         OK
+ randomStatetest520.json                                         OK
+ randomStatetest521.json                                         OK
+ randomStatetest523.json                                         OK
+ randomStatetest524.json                                         OK
+ randomStatetest525.json                                         OK
+ randomStatetest526.json                                         OK
+ randomStatetest527.json                                         OK
+ randomStatetest528.json                                         OK
+ randomStatetest531.json                                         OK
+ randomStatetest532.json                                         OK
+ randomStatetest533.json                                         OK
+ randomStatetest534.json                                         OK
+ randomStatetest535.json                                         OK
+ randomStatetest536.json                                         OK
+ randomStatetest537.json                                         OK
+ randomStatetest539.json                                         OK
+ randomStatetest541.json                                         OK
+ randomStatetest542.json                                         OK
+ randomStatetest543.json                                         OK
+ randomStatetest544.json                                         OK
+ randomStatetest545.json                                         OK
+ randomStatetest546.json                                         OK
+ randomStatetest547.json                                         OK
+ randomStatetest548.json                                         OK
+ randomStatetest550.json                                         OK
+ randomStatetest552.json                                         OK
+ randomStatetest553.json                                         OK
+ randomStatetest554.json                                         OK
+ randomStatetest555.json                                         OK
+ randomStatetest556.json                                         OK
+ randomStatetest558.json                                         OK
+ randomStatetest559.json                                         OK
+ randomStatetest560.json                                         OK
+ randomStatetest562.json                                         OK
+ randomStatetest563.json                                         OK
+ randomStatetest564.json                                         OK
+ randomStatetest565.json                                         OK
+ randomStatetest566.json                                         OK
+ randomStatetest567.json                                         OK
+ randomStatetest569.json                                         OK
+ randomStatetest571.json                                         OK
+ randomStatetest572.json                                         OK
+ randomStatetest574.json                                         OK
+ randomStatetest575.json                                         OK
+ randomStatetest576.json                                         OK
+ randomStatetest577.json                                         OK
+ randomStatetest578.json                                         OK
+ randomStatetest579.json                                         OK
+ randomStatetest580.json                                         OK
+ randomStatetest581.json                                         OK
+ randomStatetest582.json                                         OK
+ randomStatetest583.json                                         OK
+ randomStatetest584.json                                         OK
+ randomStatetest585.json                                         OK
+ randomStatetest586.json                                         OK
+ randomStatetest587.json                                         OK
+ randomStatetest588.json                                         OK
+ randomStatetest589.json                                         OK
+ randomStatetest592.json                                         OK
+ randomStatetest596.json                                         OK
+ randomStatetest597.json                                         OK
+ randomStatetest599.json                                         OK
+ randomStatetest600.json                                         OK
+ randomStatetest601.json                                         OK
+ randomStatetest602.json                                         OK
+ randomStatetest603.json                                         OK
+ randomStatetest604.json                                         OK
+ randomStatetest605.json                                         OK
+ randomStatetest607.json                                         OK
+ randomStatetest608.json                                         OK
+ randomStatetest609.json                                         OK
+ randomStatetest610.json                                         OK
+ randomStatetest611.json                                         OK
+ randomStatetest612.json                                         OK
+ randomStatetest615.json                                         OK
+ randomStatetest616.json                                         OK
+ randomStatetest618.json                                         OK
+ randomStatetest620.json                                         OK
+ randomStatetest621.json                                         OK
+ randomStatetest624.json                                         OK
+ randomStatetest625.json                                         OK
  randomStatetest626.json                                         Skip
+ randomStatetest627.json                                         OK
+ randomStatetest628.json                                         OK
+ randomStatetest629.json                                         OK
+ randomStatetest630.json                                         OK
+ randomStatetest632.json                                         OK
+ randomStatetest633.json                                         OK
+ randomStatetest635.json                                         OK
+ randomStatetest636.json                                         OK
+ randomStatetest637.json                                         OK
+ randomStatetest638.json                                         OK
+ randomStatetest639.json                                         OK
+ randomStatetest640.json                                         OK
+ randomStatetest641.json                                         OK
+ randomStatetest642.json                                         OK
+ randomStatetest643.json                                         OK
+ randomStatetest644.json                                         OK
+ randomStatetest645.json                                         OK
+ randomStatetest646.json                                         OK
+ randomStatetest647.json                                         OK
+ randomStatetest648.json                                         OK
+ randomStatetest649.json                                         OK
+ randomStatetest650.json                                         OK
```
OK: 218/220 Fail: 0/220 Skip: 2/220
## stRecursiveCreate
```diff
+ recursiveCreate.json                                            OK
  recursiveCreateReturnValue.json                                 Skip
```
OK: 1/2 Fail: 0/2 Skip: 1/2
## stRefundTest
```diff
+ refund50_1.json                                                 OK
+ refund50_2.json                                                 OK
+ refund50percentCap.json                                         OK
+ refund600.json                                                  OK
+ refundFF.json                                                   OK
+ refundMax.json                                                  OK
+ refundResetFrontier.json                                        OK
+ refundSSTORE.json                                               OK
+ refundSuicide50procentCap.json                                  OK
+ refund_CallA.json                                               OK
+ refund_CallA_OOG.json                                           OK
+ refund_CallA_notEnoughGasInCall.json                            OK
+ refund_CallToSuicideNoStorage.json                              OK
+ refund_CallToSuicideStorage.json                                OK
+ refund_CallToSuicideTwice.json                                  OK
+ refund_NoOOG_1.json                                             OK
+ refund_OOG.json                                                 OK
+ refund_TxToSuicide.json                                         OK
+ refund_TxToSuicideOOG.json                                      OK
+ refund_changeNonZeroStorage.json                                OK
+ refund_getEtherBack.json                                        OK
+ refund_multimpleSuicide.json                                    OK
+ refund_singleSuicide.json                                       OK
```
OK: 23/23 Fail: 0/23 Skip: 0/23
## stReturnDataTest
```diff
+ call_ecrec_success_empty_then_returndatasize.json               OK
+ call_outsize_then_create_successful_then_returndatasize.json    OK
+ call_then_call_value_fail_then_returndatasize.json              OK
+ call_then_create_successful_then_returndatasize.json            OK
+ clearReturnBuffer.json                                          OK
+ create_callprecompile_returndatasize.json                       OK
+ modexp_modsize0_returndatasize.json                             OK
+ returndatacopy_0_0_following_successful_create.json             OK
+ returndatacopy_afterFailing_create.json                         OK
+ returndatacopy_after_failing_callcode.json                      OK
+ returndatacopy_after_failing_delegatecall.json                  OK
+ returndatacopy_after_failing_staticcall.json                    OK
+ returndatacopy_after_revert_in_staticcall.json                  OK
+ returndatacopy_after_successful_callcode.json                   OK
+ returndatacopy_after_successful_delegatecall.json               OK
+ returndatacopy_after_successful_staticcall.json                 OK
+ returndatacopy_following_call.json                              OK
+ returndatacopy_following_create.json                            OK
+ returndatacopy_following_failing_call.json                      OK
+ returndatacopy_following_revert.json                            OK
+ returndatacopy_following_revert_in_create.json                  OK
+ returndatacopy_following_successful_create.json                 OK
+ returndatacopy_following_too_big_transfer.json                  OK
+ returndatacopy_initial.json                                     OK
+ returndatacopy_initial_256.json                                 OK
+ returndatacopy_initial_big_sum.json                             OK
+ returndatacopy_overrun.json                                     OK
+ returndatasize_after_failing_callcode.json                      OK
+ returndatasize_after_failing_delegatecall.json                  OK
+ returndatasize_after_failing_staticcall.json                    OK
+ returndatasize_after_oog_after_deeper.json                      OK
+ returndatasize_after_successful_callcode.json                   OK
+ returndatasize_after_successful_delegatecall.json               OK
+ returndatasize_after_successful_staticcall.json                 OK
+ returndatasize_bug.json                                         OK
+ returndatasize_following_successful_create.json                 OK
+ returndatasize_initial.json                                     OK
+ returndatasize_initial_zero_read.json                           OK
+ revertRetDataSize.json                                          OK
+ subcallReturnMoreThenExpected.json                              OK
+ tooLongReturnDataCopy.json                                      OK
```
OK: 41/41 Fail: 0/41 Skip: 0/41
## stRevertTest
```diff
  LoopCallsDepthThenRevert.json                                   Skip
  LoopCallsDepthThenRevert2.json                                  Skip
  LoopCallsDepthThenRevert3.json                                  Skip
  LoopCallsThenRevert.json                                        Skip
  LoopDelegateCallsDepthThenRevert.json                           Skip
+ NashatyrevSuicideRevert.json                                    OK
+ PythonRevertTestTue201814-1430.json                             OK
+ RevertDepth2.json                                               OK
+ RevertDepthCreateAddressCollision.json                          OK
+ RevertDepthCreateOOG.json                                       OK
+ RevertInCallCode.json                                           OK
+ RevertInCreateInInit.json                                       OK
+ RevertInCreateInInit_Paris.json                                 OK
+ RevertInDelegateCall.json                                       OK
+ RevertInStaticCall.json                                         OK
+ RevertOnEmptyStack.json                                         OK
+ RevertOpcode.json                                               OK
+ RevertOpcodeCalls.json                                          OK
+ RevertOpcodeCreate.json                                         OK
+ RevertOpcodeDirectCall.json                                     OK
+ RevertOpcodeInCallsOnNonEmptyReturnData.json                    OK
+ RevertOpcodeInCreateReturns.json                                OK
+ RevertOpcodeInInit.json                                         OK
+ RevertOpcodeMultipleSubCalls.json                               OK
+ RevertOpcodeReturn.json                                         OK
+ RevertOpcodeWithBigOutputInInit.json                            OK
+ RevertPrecompiledTouch.json                                     OK
+ RevertPrecompiledTouchExactOOG.json                             OK
+ RevertPrecompiledTouchExactOOG_Paris.json                       OK
+ RevertPrecompiledTouch_Paris.json                               OK
+ RevertPrecompiledTouch_nonce.json                               OK
+ RevertPrecompiledTouch_noncestorage.json                        OK
+ RevertPrecompiledTouch_storage.json                             OK
+ RevertPrecompiledTouch_storage_Paris.json                       OK
+ RevertPrefound.json                                             OK
+ RevertPrefoundCall.json                                         OK
+ RevertPrefoundCallOOG.json                                      OK
+ RevertPrefoundEmpty.json                                        OK
+ RevertPrefoundEmptyCall.json                                    OK
+ RevertPrefoundEmptyCallOOG.json                                 OK
+ RevertPrefoundEmptyCallOOG_Paris.json                           OK
+ RevertPrefoundEmptyCall_Paris.json                              OK
+ RevertPrefoundEmptyOOG.json                                     OK
+ RevertPrefoundEmptyOOG_Paris.json                               OK
+ RevertPrefoundEmpty_Paris.json                                  OK
+ RevertPrefoundOOG.json                                          OK
+ RevertRemoteSubCallStorageOOG.json                              OK
+ RevertSubCallStorageOOG.json                                    OK
+ RevertSubCallStorageOOG2.json                                   OK
+ TouchToEmptyAccountRevert.json                                  OK
+ TouchToEmptyAccountRevert2.json                                 OK
+ TouchToEmptyAccountRevert2_Paris.json                           OK
+ TouchToEmptyAccountRevert3.json                                 OK
+ TouchToEmptyAccountRevert3_Paris.json                           OK
+ TouchToEmptyAccountRevert_Paris.json                            OK
+ costRevert.json                                                 OK
+ stateRevert.json                                                OK
```
OK: 52/57 Fail: 0/57 Skip: 5/57
## stSLoadTest
```diff
+ sloadGasCost.json                                               OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## stSStoreTest
```diff
+ InitCollision.json                                              OK
+ InitCollisionNonZeroNonce.json                                  OK
+ InitCollisionParis.json                                         OK
+ SstoreCallToSelfSubRefundBelowZero.json                         OK
+ sstoreGas.json                                                  OK
+ sstore_0to0.json                                                OK
+ sstore_0to0to0.json                                             OK
+ sstore_0to0toX.json                                             OK
+ sstore_0toX.json                                                OK
+ sstore_0toXto0.json                                             OK
+ sstore_0toXto0toX.json                                          OK
+ sstore_0toXtoX.json                                             OK
+ sstore_0toXtoY.json                                             OK
+ sstore_Xto0.json                                                OK
+ sstore_Xto0to0.json                                             OK
+ sstore_Xto0toX.json                                             OK
+ sstore_Xto0toXto0.json                                          OK
+ sstore_Xto0toY.json                                             OK
+ sstore_XtoX.json                                                OK
+ sstore_XtoXto0.json                                             OK
+ sstore_XtoXtoX.json                                             OK
+ sstore_XtoXtoY.json                                             OK
+ sstore_XtoY.json                                                OK
+ sstore_XtoYto0.json                                             OK
+ sstore_XtoYtoX.json                                             OK
+ sstore_XtoYtoY.json                                             OK
+ sstore_XtoYtoZ.json                                             OK
+ sstore_changeFromExternalCallInInitCode.json                    OK
+ sstore_gasLeft.json                                             OK
```
OK: 29/29 Fail: 0/29 Skip: 0/29
## stSelfBalance
```diff
+ diffPlaces.json                                                 OK
+ selfBalance.json                                                OK
+ selfBalanceCallTypes.json                                       OK
+ selfBalanceEqualsBalance.json                                   OK
+ selfBalanceGasCost.json                                         OK
+ selfBalanceUpdate.json                                          OK
```
OK: 6/6 Fail: 0/6 Skip: 0/6
## stShift
```diff
+ sar00.json                                                      OK
+ sar01.json                                                      OK
+ sar10.json                                                      OK
+ sar11.json                                                      OK
+ sar_0_256-1.json                                                OK
+ sar_2^254_254.json                                              OK
+ sar_2^255-1_248.json                                            OK
+ sar_2^255-1_254.json                                            OK
+ sar_2^255-1_255.json                                            OK
+ sar_2^255-1_256.json                                            OK
+ sar_2^255_1.json                                                OK
+ sar_2^255_255.json                                              OK
+ sar_2^255_256.json                                              OK
+ sar_2^255_257.json                                              OK
+ sar_2^256-1_0.json                                              OK
+ sar_2^256-1_1.json                                              OK
+ sar_2^256-1_255.json                                            OK
+ sar_2^256-1_256.json                                            OK
+ shiftCombinations.json                                          OK
+ shiftSignedCombinations.json                                    OK
+ shl01-0100.json                                                 OK
+ shl01-0101.json                                                 OK
+ shl01-ff.json                                                   OK
+ shl01.json                                                      OK
+ shl10.json                                                      OK
+ shl11.json                                                      OK
+ shl_-1_0.json                                                   OK
+ shl_-1_1.json                                                   OK
+ shl_-1_255.json                                                 OK
+ shl_-1_256.json                                                 OK
+ shl_2^255-1_1.json                                              OK
+ shr01.json                                                      OK
+ shr10.json                                                      OK
+ shr11.json                                                      OK
+ shr_-1_0.json                                                   OK
+ shr_-1_1.json                                                   OK
+ shr_-1_255.json                                                 OK
+ shr_-1_256.json                                                 OK
+ shr_2^255_1.json                                                OK
+ shr_2^255_255.json                                              OK
+ shr_2^255_256.json                                              OK
+ shr_2^255_257.json                                              OK
```
OK: 42/42 Fail: 0/42 Skip: 0/42
## stSolidityTest
```diff
+ AmbiguousMethod.json                                            OK
+ ByZero.json                                                     OK
+ CallInfiniteLoop.json                                           OK
+ CallLowLevelCreatesSolidity.json                                OK
+ CallRecursiveMethods.json                                       OK
+ ContractInheritance.json                                        OK
+ CreateContractFromMethod.json                                   OK
+ RecursiveCreateContracts.json                                   OK
+ RecursiveCreateContractsCreate4Contracts.json                   OK
+ SelfDestruct.json                                               OK
+ TestBlockAndTransactionProperties.json                          OK
+ TestContractInteraction.json                                    OK
+ TestContractSuicide.json                                        OK
+ TestCryptographicFunctions.json                                 OK
+ TestKeywords.json                                               OK
+ TestOverflow.json                                               OK
+ TestStoreGasPrices.json                                         OK
+ TestStructuresAndVariabless.json                                OK
```
OK: 18/18 Fail: 0/18 Skip: 0/18
## stSpecialTest
```diff
+ FailedCreateRevertsDeletion.json                                OK
+ FailedCreateRevertsDeletionParis.json                           OK
  JUMPDEST_Attack.json                                            Skip
  JUMPDEST_AttackwithJump.json                                    Skip
+ OverflowGasMakeMoney.json                                       OK
+ StackDepthLimitSEC.json                                         OK
+ block504980.json                                                OK
+ deploymentError.json                                            OK
+ eoaEmpty.json                                                   OK
+ eoaEmptyParis.json                                              OK
+ failed_tx_xcf416c53.json                                        OK
+ failed_tx_xcf416c53_Paris.json                                  OK
+ gasPrice0.json                                                  OK
+ makeMoney.json                                                  OK
+ push32withoutByte.json                                          OK
+ selfdestructEIP2929.json                                        OK
+ sha3_deja.json                                                  OK
+ tx_e1c174e2.json                                                OK
```
OK: 16/18 Fail: 0/18 Skip: 2/18
## stStackTests
```diff
+ shallowStack.json                                               OK
+ stackOverflow.json                                              OK
+ stackOverflowDUP.json                                           OK
+ stackOverflowM1.json                                            OK
+ stackOverflowM1DUP.json                                         OK
+ stackOverflowM1PUSH.json                                        OK
+ stackOverflowPUSH.json                                          OK
+ stackOverflowSWAP.json                                          OK
+ stacksanitySWAP.json                                            OK
+ underflowTest.json                                              OK
```
OK: 10/10 Fail: 0/10 Skip: 0/10
## stStaticCall
```diff
+ StaticcallToPrecompileFromCalledContract.json                   OK
+ StaticcallToPrecompileFromContractInitialization.json           OK
+ StaticcallToPrecompileFromTransaction.json                      OK
+ static_ABAcalls0.json                                           OK
+ static_ABAcalls1.json                                           OK
+ static_ABAcalls2.json                                           OK
+ static_ABAcalls3.json                                           OK
+ static_ABAcallsSuicide0.json                                    OK
+ static_ABAcallsSuicide1.json                                    OK
+ static_CALL_OneVCallSuicide.json                                OK
+ static_CALL_ZeroVCallSuicide.json                               OK
+ static_CREATE_ContractSuicideDuringInit.json                    OK
+ static_CREATE_ContractSuicideDuringInit_ThenStoreThenReturn.jso OK
+ static_CREATE_ContractSuicideDuringInit_WithValue.json          OK
+ static_CREATE_EmptyContractAndCallIt_0wei.json                  OK
+ static_CREATE_EmptyContractWithStorageAndCallIt_0wei.json       OK
+ static_Call10.json                                              OK
  static_Call1024BalanceTooLow.json                               Skip
  static_Call1024BalanceTooLow2.json                              Skip
  static_Call1024OOG.json                                         Skip
  static_Call1024PreCalls.json                                    Skip
  static_Call1024PreCalls2.json                                   Skip
  static_Call1024PreCalls3.json                                   Skip
  static_Call1MB1024Calldepth.json                                Skip
  static_Call50000.json                                           Skip
  static_Call50000_ecrec.json                                     Skip
  static_Call50000_identity.json                                  Skip
  static_Call50000_identity2.json                                 Skip
  static_Call50000_rip160.json                                    Skip
+ static_Call50000bytesContract50_1.json                          OK
+ static_Call50000bytesContract50_2.json                          OK
+ static_Call50000bytesContract50_3.json                          OK
+ static_CallAndCallcodeConsumeMoreGasThenTransactionHas.json     OK
+ static_CallAskMoreGasOnDepth2ThenTransactionHas.json            OK
+ static_CallContractToCreateContractAndCallItOOG.json            OK
+ static_CallContractToCreateContractOOG.json                     OK
+ static_CallContractToCreateContractOOGBonusGas.json             OK
+ static_CallContractToCreateContractWhichWouldCreateContractIfCa OK
+ static_CallEcrecover0.json                                      OK
+ static_CallEcrecover0_0input.json                               OK
+ static_CallEcrecover0_Gas2999.json                              OK
+ static_CallEcrecover0_NoGas.json                                OK
+ static_CallEcrecover0_completeReturnValue.json                  OK
+ static_CallEcrecover0_gas3000.json                              OK
+ static_CallEcrecover0_overlappingInputOutput.json               OK
+ static_CallEcrecover1.json                                      OK
+ static_CallEcrecover2.json                                      OK
+ static_CallEcrecover3.json                                      OK
+ static_CallEcrecover80.json                                     OK
+ static_CallEcrecoverCheckLength.json                            OK
+ static_CallEcrecoverCheckLengthWrongV.json                      OK
+ static_CallEcrecoverH_prefixed0.json                            OK
+ static_CallEcrecoverR_prefixed0.json                            OK
+ static_CallEcrecoverS_prefixed0.json                            OK
+ static_CallEcrecoverV_prefixed0.json                            OK
+ static_CallGoesOOGOnSecondLevel.json                            OK
+ static_CallGoesOOGOnSecondLevel2.json                           OK
+ static_CallIdentitiy_1.json                                     OK
+ static_CallIdentity_1_nonzeroValue.json                         OK
+ static_CallIdentity_2.json                                      OK
+ static_CallIdentity_3.json                                      OK
+ static_CallIdentity_4.json                                      OK
+ static_CallIdentity_4_gas17.json                                OK
+ static_CallIdentity_4_gas18.json                                OK
+ static_CallIdentity_5.json                                      OK
+ static_CallLoseGasOOG.json                                      OK
+ static_CallRecursiveBomb0.json                                  OK
+ static_CallRecursiveBomb0_OOG_atMaxCallDepth.json               OK
+ static_CallRecursiveBomb1.json                                  OK
+ static_CallRecursiveBomb2.json                                  OK
+ static_CallRecursiveBomb3.json                                  OK
+ static_CallRecursiveBombLog.json                                OK
+ static_CallRecursiveBombLog2.json                               OK
+ static_CallRecursiveBombPreCall.json                            OK
+ static_CallRecursiveBombPreCall2.json                           OK
+ static_CallRipemd160_1.json                                     OK
+ static_CallRipemd160_2.json                                     OK
+ static_CallRipemd160_3.json                                     OK
+ static_CallRipemd160_3_postfixed0.json                          OK
+ static_CallRipemd160_3_prefixed0.json                           OK
+ static_CallRipemd160_4.json                                     OK
+ static_CallRipemd160_4_gas719.json                              OK
+ static_CallRipemd160_5.json                                     OK
+ static_CallSha256_1.json                                        OK
+ static_CallSha256_1_nonzeroValue.json                           OK
+ static_CallSha256_2.json                                        OK
+ static_CallSha256_3.json                                        OK
+ static_CallSha256_3_postfix0.json                               OK
+ static_CallSha256_3_prefix0.json                                OK
+ static_CallSha256_4.json                                        OK
+ static_CallSha256_4_gas99.json                                  OK
+ static_CallSha256_5.json                                        OK
+ static_CallToNameRegistrator0.json                              OK
+ static_CallToReturn1.json                                       OK
+ static_CalltoReturn2.json                                       OK
+ static_CheckCallCostOOG.json                                    OK
+ static_CheckOpcodes.json                                        OK
+ static_CheckOpcodes2.json                                       OK
+ static_CheckOpcodes3.json                                       OK
+ static_CheckOpcodes4.json                                       OK
+ static_CheckOpcodes5.json                                       OK
+ static_ExecuteCallThatAskForeGasThenTrabsactionHas.json         OK
+ static_InternalCallHittingGasLimit.json                         OK
+ static_InternalCallHittingGasLimit2.json                        OK
+ static_InternlCallStoreClearsOOG.json                           OK
+ static_LoopCallsDepthThenRevert.json                            OK
+ static_LoopCallsDepthThenRevert2.json                           OK
+ static_LoopCallsDepthThenRevert3.json                           OK
+ static_LoopCallsThenRevert.json                                 OK
+ static_PostToReturn1.json                                       OK
+ static_RETURN_Bounds.json                                       OK
+ static_RETURN_BoundsOOG.json                                    OK
+ static_RawCallGasAsk.json                                       OK
+ static_Return50000_2.json                                       OK
+ static_ReturnTest.json                                          OK
+ static_ReturnTest2.json                                         OK
+ static_RevertDepth2.json                                        OK
+ static_RevertOpcodeCalls.json                                   OK
+ static_ZeroValue_CALL_OOGRevert.json                            OK
+ static_ZeroValue_SUICIDE_OOGRevert.json                         OK
+ static_callBasic.json                                           OK
+ static_callChangeRevert.json                                    OK
+ static_callCreate.json                                          OK
+ static_callCreate2.json                                         OK
+ static_callCreate3.json                                         OK
+ static_callOutput1.json                                         OK
+ static_callOutput2.json                                         OK
+ static_callOutput3.json                                         OK
+ static_callOutput3Fail.json                                     OK
+ static_callOutput3partial.json                                  OK
+ static_callOutput3partialFail.json                              OK
+ static_callToCallCodeOpCodeCheck.json                           OK
+ static_callToCallOpCodeCheck.json                               OK
+ static_callToDelCallOpCodeCheck.json                            OK
+ static_callToStaticOpCodeCheck.json                             OK
+ static_callWithHighValue.json                                   OK
+ static_callWithHighValueAndGasOOG.json                          OK
+ static_callWithHighValueAndOOGatTxLevel.json                    OK
+ static_callWithHighValueOOGinCall.json                          OK
+ static_call_OOG_additionalGasCosts1.json                        OK
+ static_call_OOG_additionalGasCosts2.json                        OK
+ static_call_OOG_additionalGasCosts2_Paris.json                  OK
+ static_call_value_inherit.json                                  OK
+ static_call_value_inherit_from_call.json                        OK
+ static_callcall_00.json                                         OK
+ static_callcall_00_OOGE.json                                    OK
+ static_callcall_00_OOGE_1.json                                  OK
+ static_callcall_00_OOGE_2.json                                  OK
+ static_callcall_00_SuicideEnd.json                              OK
+ static_callcallcall_000.json                                    OK
+ static_callcallcall_000_OOGE.json                               OK
+ static_callcallcall_000_OOGMAfter.json                          OK
+ static_callcallcall_000_OOGMAfter2.json                         OK
+ static_callcallcall_000_OOGMBefore.json                         OK
+ static_callcallcall_000_SuicideEnd.json                         OK
+ static_callcallcall_000_SuicideMiddle.json                      OK
+ static_callcallcall_ABCB_RECURSIVE.json                         OK
+ static_callcallcallcode_001.json                                OK
+ static_callcallcallcode_001_2.json                              OK
+ static_callcallcallcode_001_OOGE.json                           OK
+ static_callcallcallcode_001_OOGE_2.json                         OK
+ static_callcallcallcode_001_OOGMAfter.json                      OK
+ static_callcallcallcode_001_OOGMAfter2.json                     OK
+ static_callcallcallcode_001_OOGMAfter_2.json                    OK
+ static_callcallcallcode_001_OOGMAfter_3.json                    OK
+ static_callcallcallcode_001_OOGMBefore.json                     OK
+ static_callcallcallcode_001_OOGMBefore2.json                    OK
+ static_callcallcallcode_001_SuicideEnd.json                     OK
+ static_callcallcallcode_001_SuicideEnd2.json                    OK
+ static_callcallcallcode_001_SuicideMiddle.json                  OK
+ static_callcallcallcode_001_SuicideMiddle2.json                 OK
+ static_callcallcallcode_ABCB_RECURSIVE.json                     OK
+ static_callcallcallcode_ABCB_RECURSIVE2.json                    OK
+ static_callcallcode_01_2.json                                   OK
+ static_callcallcode_01_OOGE_2.json                              OK
+ static_callcallcode_01_SuicideEnd.json                          OK
+ static_callcallcode_01_SuicideEnd2.json                         OK
+ static_callcallcodecall_010.json                                OK
+ static_callcallcodecall_010_2.json                              OK
+ static_callcallcodecall_010_OOGE.json                           OK
+ static_callcallcodecall_010_OOGE_2.json                         OK
+ static_callcallcodecall_010_OOGMAfter.json                      OK
+ static_callcallcodecall_010_OOGMAfter2.json                     OK
+ static_callcallcodecall_010_OOGMAfter_2.json                    OK
+ static_callcallcodecall_010_OOGMAfter_3.json                    OK
+ static_callcallcodecall_010_OOGMBefore.json                     OK
+ static_callcallcodecall_010_OOGMBefore2.json                    OK
+ static_callcallcodecall_010_SuicideEnd.json                     OK
+ static_callcallcodecall_010_SuicideEnd2.json                    OK
+ static_callcallcodecall_010_SuicideMiddle.json                  OK
+ static_callcallcodecall_010_SuicideMiddle2.json                 OK
+ static_callcallcodecall_ABCB_RECURSIVE.json                     OK
+ static_callcallcodecall_ABCB_RECURSIVE2.json                    OK
+ static_callcallcodecallcode_011.json                            OK
+ static_callcallcodecallcode_011_2.json                          OK
+ static_callcallcodecallcode_011_OOGE.json                       OK
+ static_callcallcodecallcode_011_OOGE_2.json                     OK
+ static_callcallcodecallcode_011_OOGMAfter.json                  OK
+ static_callcallcodecallcode_011_OOGMAfter2.json                 OK
+ static_callcallcodecallcode_011_OOGMAfter_1.json                OK
+ static_callcallcodecallcode_011_OOGMAfter_2.json                OK
+ static_callcallcodecallcode_011_OOGMBefore.json                 OK
+ static_callcallcodecallcode_011_OOGMBefore2.json                OK
+ static_callcallcodecallcode_011_SuicideEnd.json                 OK
+ static_callcallcodecallcode_011_SuicideEnd2.json                OK
+ static_callcallcodecallcode_011_SuicideMiddle.json              OK
+ static_callcallcodecallcode_011_SuicideMiddle2.json             OK
+ static_callcallcodecallcode_ABCB_RECURSIVE.json                 OK
+ static_callcallcodecallcode_ABCB_RECURSIVE2.json                OK
+ static_callcode_checkPC.json                                    OK
+ static_callcodecall_10.json                                     OK
+ static_callcodecall_10_2.json                                   OK
+ static_callcodecall_10_OOGE.json                                OK
+ static_callcodecall_10_OOGE_2.json                              OK
+ static_callcodecall_10_SuicideEnd.json                          OK
+ static_callcodecall_10_SuicideEnd2.json                         OK
+ static_callcodecallcall_100.json                                OK
+ static_callcodecallcall_100_2.json                              OK
+ static_callcodecallcall_100_OOGE.json                           OK
+ static_callcodecallcall_100_OOGE2.json                          OK
+ static_callcodecallcall_100_OOGMAfter.json                      OK
+ static_callcodecallcall_100_OOGMAfter2.json                     OK
+ static_callcodecallcall_100_OOGMAfter_2.json                    OK
+ static_callcodecallcall_100_OOGMAfter_3.json                    OK
+ static_callcodecallcall_100_OOGMBefore.json                     OK
+ static_callcodecallcall_100_OOGMBefore2.json                    OK
+ static_callcodecallcall_100_SuicideEnd.json                     OK
+ static_callcodecallcall_100_SuicideEnd2.json                    OK
+ static_callcodecallcall_100_SuicideMiddle.json                  OK
+ static_callcodecallcall_100_SuicideMiddle2.json                 OK
+ static_callcodecallcall_ABCB_RECURSIVE.json                     OK
+ static_callcodecallcall_ABCB_RECURSIVE2.json                    OK
+ static_callcodecallcallcode_101.json                            OK
+ static_callcodecallcallcode_101_2.json                          OK
+ static_callcodecallcallcode_101_OOGE.json                       OK
+ static_callcodecallcallcode_101_OOGE_2.json                     OK
+ static_callcodecallcallcode_101_OOGMAfter.json                  OK
+ static_callcodecallcallcode_101_OOGMAfter2.json                 OK
+ static_callcodecallcallcode_101_OOGMAfter_1.json                OK
+ static_callcodecallcallcode_101_OOGMAfter_3.json                OK
+ static_callcodecallcallcode_101_OOGMBefore.json                 OK
+ static_callcodecallcallcode_101_OOGMBefore2.json                OK
+ static_callcodecallcallcode_101_SuicideEnd.json                 OK
+ static_callcodecallcallcode_101_SuicideEnd2.json                OK
+ static_callcodecallcallcode_101_SuicideMiddle.json              OK
+ static_callcodecallcallcode_101_SuicideMiddle2.json             OK
+ static_callcodecallcallcode_ABCB_RECURSIVE.json                 OK
+ static_callcodecallcallcode_ABCB_RECURSIVE2.json                OK
+ static_callcodecallcodecall_110.json                            OK
+ static_callcodecallcodecall_1102.json                           OK
+ static_callcodecallcodecall_110_2.json                          OK
+ static_callcodecallcodecall_110_OOGE.json                       OK
+ static_callcodecallcodecall_110_OOGE2.json                      OK
+ static_callcodecallcodecall_110_OOGMAfter.json                  OK
+ static_callcodecallcodecall_110_OOGMAfter2.json                 OK
+ static_callcodecallcodecall_110_OOGMAfter_2.json                OK
+ static_callcodecallcodecall_110_OOGMAfter_3.json                OK
+ static_callcodecallcodecall_110_OOGMBefore.json                 OK
+ static_callcodecallcodecall_110_OOGMBefore2.json                OK
+ static_callcodecallcodecall_110_SuicideEnd.json                 OK
+ static_callcodecallcodecall_110_SuicideEnd2.json                OK
+ static_callcodecallcodecall_110_SuicideMiddle.json              OK
+ static_callcodecallcodecall_110_SuicideMiddle2.json             OK
+ static_callcodecallcodecall_ABCB_RECURSIVE.json                 OK
+ static_callcodecallcodecall_ABCB_RECURSIVE2.json                OK
+ static_callcodecallcodecallcode_111_SuicideEnd.json             OK
+ static_calldelcode_01.json                                      OK
+ static_calldelcode_01_OOGE.json                                 OK
+ static_contractCreationMakeCallThatAskMoreGasThenTransactionPro OK
+ static_contractCreationOOGdontLeaveEmptyContractViaTransaction. OK
+ static_log0_emptyMem.json                                       OK
+ static_log0_logMemStartTooHigh.json                             OK
+ static_log0_logMemsizeTooHigh.json                              OK
+ static_log0_logMemsizeZero.json                                 OK
+ static_log0_nonEmptyMem.json                                    OK
+ static_log0_nonEmptyMem_logMemSize1.json                        OK
+ static_log0_nonEmptyMem_logMemSize1_logMemStart31.json          OK
+ static_log1_MaxTopic.json                                       OK
+ static_log1_emptyMem.json                                       OK
+ static_log1_logMemStartTooHigh.json                             OK
+ static_log1_logMemsizeTooHigh.json                              OK
+ static_log1_logMemsizeZero.json                                 OK
+ static_log_Caller.json                                          OK
+ static_makeMoney.json                                           OK
+ static_refund_CallA.json                                        OK
+ static_refund_CallToSuicideNoStorage.json                       OK
+ static_refund_CallToSuicideTwice.json                           OK
```
OK: 275/287 Fail: 0/287 Skip: 12/287
## stStaticFlagEnabled
```diff
+ CallWithNOTZeroValueToPrecompileFromCalledContract.json         OK
+ CallWithNOTZeroValueToPrecompileFromContractInitialization.json OK
+ CallWithNOTZeroValueToPrecompileFromTransaction.json            OK
+ CallWithZeroValueToPrecompileFromCalledContract.json            OK
+ CallWithZeroValueToPrecompileFromContractInitialization.json    OK
+ CallWithZeroValueToPrecompileFromTransaction.json               OK
+ CallcodeToPrecompileFromCalledContract.json                     OK
+ CallcodeToPrecompileFromContractInitialization.json             OK
+ CallcodeToPrecompileFromTransaction.json                        OK
+ DelegatecallToPrecompileFromCalledContract.json                 OK
+ DelegatecallToPrecompileFromContractInitialization.json         OK
+ DelegatecallToPrecompileFromTransaction.json                    OK
+ StaticcallForPrecompilesIssue683.json                           OK
```
OK: 13/13 Fail: 0/13 Skip: 0/13
## stSystemOperationsTest
```diff
+ ABAcalls0.json                                                  OK
  ABAcalls1.json                                                  Skip
  ABAcalls2.json                                                  Skip
+ ABAcalls3.json                                                  OK
+ ABAcallsSuicide0.json                                           OK
+ ABAcallsSuicide1.json                                           OK
+ Call10.json                                                     OK
  CallRecursiveBomb0.json                                         Skip
  CallRecursiveBomb0_OOG_atMaxCallDepth.json                      Skip
  CallRecursiveBomb1.json                                         Skip
  CallRecursiveBomb2.json                                         Skip
+ CallRecursiveBomb3.json                                         OK
  CallRecursiveBombLog.json                                       Skip
  CallRecursiveBombLog2.json                                      Skip
+ CallToNameRegistrator0.json                                     OK
+ CallToNameRegistratorAddressTooBigLeft.json                     OK
+ CallToNameRegistratorAddressTooBigRight.json                    OK
  CallToNameRegistratorMemOOGAndInsufficientBalance.json          Skip
+ CallToNameRegistratorNotMuchMemory0.json                        OK
+ CallToNameRegistratorNotMuchMemory1.json                        OK
+ CallToNameRegistratorOutOfGas.json                              OK
  CallToNameRegistratorTooMuchMemory0.json                        Skip
+ CallToNameRegistratorTooMuchMemory1.json                        OK
+ CallToNameRegistratorTooMuchMemory2.json                        OK
+ CallToNameRegistratorZeorSizeMemExpansion.json                  OK
+ CallToReturn1.json                                              OK
+ CallToReturn1ForDynamicJump0.json                               OK
+ CallToReturn1ForDynamicJump1.json                               OK
+ CalltoReturn2.json                                              OK
+ CreateHashCollision.json                                        OK
+ PostToReturn1.json                                              OK
+ TestNameRegistrator.json                                        OK
+ balanceInputAddressTooBig.json                                  OK
+ callValue.json                                                  OK
+ callcodeTo0.json                                                OK
+ callcodeToNameRegistrator0.json                                 OK
+ callcodeToNameRegistratorAddresTooBigLeft.json                  OK
+ callcodeToNameRegistratorAddresTooBigRight.json                 OK
+ callcodeToNameRegistratorZeroMemExpanion.json                   OK
+ callcodeToReturn1.json                                          OK
+ callerAccountBalance.json                                       OK
+ createNameRegistrator.json                                      OK
+ createNameRegistratorOOG_MemExpansionOOV.json                   OK
+ createNameRegistratorOutOfMemoryBonds0.json                     OK
+ createNameRegistratorOutOfMemoryBonds1.json                     OK
+ createNameRegistratorValueTooHigh.json                          OK
+ createNameRegistratorZeroMem.json                               OK
+ createNameRegistratorZeroMem2.json                              OK
+ createNameRegistratorZeroMemExpansion.json                      OK
+ createWithInvalidOpcode.json                                    OK
+ currentAccountBalance.json                                      OK
+ doubleSelfdestructTest.json                                     OK
+ doubleSelfdestructTouch.json                                    OK
+ doubleSelfdestructTouch_Paris.json                              OK
+ extcodecopy.json                                                OK
+ multiSelfdestruct.json                                          OK
+ return0.json                                                    OK
+ return1.json                                                    OK
+ return2.json                                                    OK
+ suicideAddress.json                                             OK
+ suicideCaller.json                                              OK
+ suicideCallerAddresTooBigLeft.json                              OK
+ suicideCallerAddresTooBigRight.json                             OK
+ suicideNotExistingAccount.json                                  OK
+ suicideOrigin.json                                              OK
+ suicideSendEtherPostDeath.json                                  OK
+ suicideSendEtherToMe.json                                       OK
+ testRandomTest.json                                             OK
```
OK: 58/68 Fail: 0/68 Skip: 10/68
## stTimeConsuming
```diff
  CALLBlake2f_MaxRounds.json                                      Skip
+ sstore_combinations_initial00.json                              OK
+ sstore_combinations_initial00_2.json                            OK
+ sstore_combinations_initial00_2_Paris.json                      OK
+ sstore_combinations_initial00_Paris.json                        OK
+ sstore_combinations_initial01.json                              OK
+ sstore_combinations_initial01_2.json                            OK
+ sstore_combinations_initial01_2_Paris.json                      OK
+ sstore_combinations_initial01_Paris.json                        OK
+ sstore_combinations_initial10.json                              OK
+ sstore_combinations_initial10_2.json                            OK
+ sstore_combinations_initial10_2_Paris.json                      OK
+ sstore_combinations_initial10_Paris.json                        OK
+ sstore_combinations_initial11.json                              OK
+ sstore_combinations_initial11_2.json                            OK
+ sstore_combinations_initial11_2_Paris.json                      OK
+ sstore_combinations_initial11_Paris.json                        OK
+ sstore_combinations_initial20.json                              OK
+ sstore_combinations_initial20_2.json                            OK
+ sstore_combinations_initial20_2_Paris.json                      OK
+ sstore_combinations_initial20_Paris.json                        OK
+ sstore_combinations_initial21.json                              OK
+ sstore_combinations_initial21_2.json                            OK
+ sstore_combinations_initial21_2_Paris.json                      OK
+ sstore_combinations_initial21_Paris.json                        OK
  static_Call50000_sha256.json                                    Skip
```
OK: 24/26 Fail: 0/26 Skip: 2/26
## stTransactionTest
```diff
+ ContractStoreClearsOOG.json                                     OK
+ ContractStoreClearsSuccess.json                                 OK
+ CreateMessageReverted.json                                      OK
+ CreateMessageSuccess.json                                       OK
+ CreateTransactionSuccess.json                                   OK
+ EmptyTransaction3.json                                          OK
+ HighGasLimit.json                                               OK
+ HighGasPrice.json                                               OK
+ HighGasPriceParis.json                                          OK
+ InternalCallHittingGasLimit.json                                OK
+ InternalCallHittingGasLimit2.json                               OK
+ InternalCallHittingGasLimitSuccess.json                         OK
+ InternlCallStoreClearsOOG.json                                  OK
+ InternlCallStoreClearsSucces.json                               OK
+ NoSrcAccount.json                                               OK
+ NoSrcAccount1559.json                                           OK
+ NoSrcAccountCreate.json                                         OK
+ NoSrcAccountCreate1559.json                                     OK
+ Opcodes_TransactionInit.json                                    OK
+ OverflowGasRequire2.json                                        OK
+ PointAtInfinityECRecover.json                                   OK
+ StoreClearsAndInternlCallStoreClearsOOG.json                    OK
+ StoreClearsAndInternlCallStoreClearsSuccess.json                OK
+ StoreGasOnCreate.json                                           OK
+ SuicidesAndInternlCallSuicidesBonusGasAtCall.json               OK
+ SuicidesAndInternlCallSuicidesBonusGasAtCallFailed.json         OK
+ SuicidesAndInternlCallSuicidesOOG.json                          OK
+ SuicidesAndInternlCallSuicidesSuccess.json                      OK
+ SuicidesAndSendMoneyToItselfEtherDestroyed.json                 OK
+ SuicidesStopAfterSuicide.json                                   OK
+ TransactionDataCosts652.json                                    OK
+ TransactionSendingToEmpty.json                                  OK
+ TransactionSendingToZero.json                                   OK
+ TransactionToAddressh160minusOne.json                           OK
+ TransactionToItself.json                                        OK
+ ValueOverflow.json                                              OK
+ ValueOverflowParis.json                                         OK
```
OK: 37/37 Fail: 0/37 Skip: 0/37
## stTransitionTest
```diff
+ createNameRegistratorPerTxsAfter.json                           OK
+ createNameRegistratorPerTxsAt.json                              OK
+ createNameRegistratorPerTxsBefore.json                          OK
+ delegatecallAfterTransition.json                                OK
+ delegatecallAtTransition.json                                   OK
+ delegatecallBeforeTransition.json                               OK
```
OK: 6/6 Fail: 0/6 Skip: 0/6
## stWalletTest
```diff
+ dayLimitConstruction.json                                       OK
+ dayLimitConstructionOOG.json                                    OK
+ dayLimitConstructionPartial.json                                OK
+ dayLimitResetSpentToday.json                                    OK
+ dayLimitSetDailyLimit.json                                      OK
+ dayLimitSetDailyLimitNoData.json                                OK
+ multiOwnedAddOwner.json                                         OK
+ multiOwnedAddOwnerAddMyself.json                                OK
+ multiOwnedChangeOwner.json                                      OK
+ multiOwnedChangeOwnerNoArgument.json                            OK
+ multiOwnedChangeOwner_fromNotOwner.json                         OK
+ multiOwnedChangeOwner_toIsOwner.json                            OK
+ multiOwnedChangeRequirementTo0.json                             OK
+ multiOwnedChangeRequirementTo1.json                             OK
+ multiOwnedChangeRequirementTo2.json                             OK
+ multiOwnedConstructionCorrect.json                              OK
+ multiOwnedConstructionNotEnoughGas.json                         OK
+ multiOwnedConstructionNotEnoughGasPartial.json                  OK
+ multiOwnedIsOwnerFalse.json                                     OK
+ multiOwnedIsOwnerTrue.json                                      OK
+ multiOwnedRemoveOwner.json                                      OK
+ multiOwnedRemoveOwnerByNonOwner.json                            OK
+ multiOwnedRemoveOwner_mySelf.json                               OK
+ multiOwnedRemoveOwner_ownerIsNotOwner.json                      OK
+ multiOwnedRevokeNothing.json                                    OK
+ walletAddOwnerRemovePendingTransaction.json                     OK
+ walletChangeOwnerRemovePendingTransaction.json                  OK
+ walletChangeRequirementRemovePendingTransaction.json            OK
+ walletConfirm.json                                              OK
+ walletConstruction.json                                         OK
+ walletConstructionOOG.json                                      OK
+ walletConstructionPartial.json                                  OK
+ walletDefault.json                                              OK
+ walletDefaultWithOutValue.json                                  OK
+ walletExecuteOverDailyLimitMultiOwner.json                      OK
+ walletExecuteOverDailyLimitOnlyOneOwner.json                    OK
+ walletExecuteOverDailyLimitOnlyOneOwnerNew.json                 OK
+ walletExecuteUnderDailyLimit.json                               OK
+ walletKill.json                                                 OK
+ walletKillNotByOwner.json                                       OK
+ walletKillToWallet.json                                         OK
+ walletRemoveOwnerRemovePendingTransaction.json                  OK
```
OK: 42/42 Fail: 0/42 Skip: 0/42
## stZeroCallsRevert
```diff
+ ZeroValue_CALLCODE_OOGRevert.json                               OK
+ ZeroValue_CALLCODE_ToEmpty_OOGRevert.json                       OK
+ ZeroValue_CALLCODE_ToEmpty_OOGRevert_Paris.json                 OK
+ ZeroValue_CALLCODE_ToNonZeroBalance_OOGRevert.json              OK
+ ZeroValue_CALLCODE_ToOneStorageKey_OOGRevert.json               OK
+ ZeroValue_CALLCODE_ToOneStorageKey_OOGRevert_Paris.json         OK
+ ZeroValue_CALL_OOGRevert.json                                   OK
+ ZeroValue_CALL_ToEmpty_OOGRevert.json                           OK
+ ZeroValue_CALL_ToEmpty_OOGRevert_Paris.json                     OK
+ ZeroValue_CALL_ToNonZeroBalance_OOGRevert.json                  OK
+ ZeroValue_CALL_ToOneStorageKey_OOGRevert.json                   OK
+ ZeroValue_CALL_ToOneStorageKey_OOGRevert_Paris.json             OK
+ ZeroValue_DELEGATECALL_OOGRevert.json                           OK
+ ZeroValue_DELEGATECALL_ToEmpty_OOGRevert.json                   OK
+ ZeroValue_DELEGATECALL_ToEmpty_OOGRevert_Paris.json             OK
+ ZeroValue_DELEGATECALL_ToNonZeroBalance_OOGRevert.json          OK
+ ZeroValue_DELEGATECALL_ToOneStorageKey_OOGRevert.json           OK
+ ZeroValue_DELEGATECALL_ToOneStorageKey_OOGRevert_Paris.json     OK
+ ZeroValue_SUICIDE_OOGRevert.json                                OK
+ ZeroValue_SUICIDE_ToEmpty_OOGRevert.json                        OK
+ ZeroValue_SUICIDE_ToEmpty_OOGRevert_Paris.json                  OK
+ ZeroValue_SUICIDE_ToNonZeroBalance_OOGRevert.json               OK
+ ZeroValue_SUICIDE_ToOneStorageKey_OOGRevert.json                OK
+ ZeroValue_SUICIDE_ToOneStorageKey_OOGRevert_Paris.json          OK
```
OK: 24/24 Fail: 0/24 Skip: 0/24
## stZeroCallsTest
```diff
+ ZeroValue_CALL.json                                             OK
+ ZeroValue_CALLCODE.json                                         OK
+ ZeroValue_CALLCODE_ToEmpty.json                                 OK
+ ZeroValue_CALLCODE_ToEmpty_Paris.json                           OK
+ ZeroValue_CALLCODE_ToNonZeroBalance.json                        OK
+ ZeroValue_CALLCODE_ToOneStorageKey.json                         OK
+ ZeroValue_CALLCODE_ToOneStorageKey_Paris.json                   OK
+ ZeroValue_CALL_ToEmpty.json                                     OK
+ ZeroValue_CALL_ToEmpty_Paris.json                               OK
+ ZeroValue_CALL_ToNonZeroBalance.json                            OK
+ ZeroValue_CALL_ToOneStorageKey.json                             OK
+ ZeroValue_CALL_ToOneStorageKey_Paris.json                       OK
+ ZeroValue_DELEGATECALL.json                                     OK
+ ZeroValue_DELEGATECALL_ToEmpty.json                             OK
+ ZeroValue_DELEGATECALL_ToEmpty_Paris.json                       OK
+ ZeroValue_DELEGATECALL_ToNonZeroBalance.json                    OK
+ ZeroValue_DELEGATECALL_ToOneStorageKey.json                     OK
+ ZeroValue_DELEGATECALL_ToOneStorageKey_Paris.json               OK
+ ZeroValue_SUICIDE.json                                          OK
+ ZeroValue_SUICIDE_ToEmpty.json                                  OK
+ ZeroValue_SUICIDE_ToEmpty_Paris.json                            OK
+ ZeroValue_SUICIDE_ToNonZeroBalance.json                         OK
+ ZeroValue_SUICIDE_ToOneStorageKey.json                          OK
+ ZeroValue_SUICIDE_ToOneStorageKey_Paris.json                    OK
+ ZeroValue_TransactionCALL.json                                  OK
+ ZeroValue_TransactionCALL_ToEmpty.json                          OK
+ ZeroValue_TransactionCALL_ToEmpty_Paris.json                    OK
+ ZeroValue_TransactionCALL_ToNonZeroBalance.json                 OK
+ ZeroValue_TransactionCALL_ToOneStorageKey.json                  OK
+ ZeroValue_TransactionCALL_ToOneStorageKey_Paris.json            OK
+ ZeroValue_TransactionCALLwithData.json                          OK
+ ZeroValue_TransactionCALLwithData_ToEmpty.json                  OK
+ ZeroValue_TransactionCALLwithData_ToEmpty_Paris.json            OK
+ ZeroValue_TransactionCALLwithData_ToNonZeroBalance.json         OK
+ ZeroValue_TransactionCALLwithData_ToOneStorageKey.json          OK
+ ZeroValue_TransactionCALLwithData_ToOneStorageKey_Paris.json    OK
```
OK: 36/36 Fail: 0/36 Skip: 0/36
## stZeroKnowledge
```diff
+ ecmul_1-2_2_28000_128.json                                      OK
+ ecmul_1-2_2_28000_96.json                                       OK
+ ecmul_1-2_340282366920938463463374607431768211456_21000_128.jso OK
+ ecmul_1-2_340282366920938463463374607431768211456_21000_80.json OK
+ ecmul_1-2_340282366920938463463374607431768211456_21000_96.json OK
+ ecmul_1-2_340282366920938463463374607431768211456_28000_128.jso OK
+ ecmul_1-2_340282366920938463463374607431768211456_28000_80.json OK
+ ecmul_1-2_340282366920938463463374607431768211456_28000_96.json OK
+ ecmul_1-2_5616_21000_128.json                                   OK
+ ecmul_1-2_5616_21000_96.json                                    OK
+ ecmul_1-2_5616_28000_128.json                                   OK
+ ecmul_1-2_5617_21000_128.json                                   OK
+ ecmul_1-2_5617_21000_96.json                                    OK
+ ecmul_1-2_5617_28000_128.json                                   OK
+ ecmul_1-2_5617_28000_96.json                                    OK
+ ecmul_1-2_616_28000_96.json                                     OK
+ ecmul_1-2_9935_21000_128.json                                   OK
+ ecmul_1-2_9935_21000_96.json                                    OK
+ ecmul_1-2_9935_28000_128.json                                   OK
+ ecmul_1-2_9935_28000_96.json                                    OK
+ ecmul_1-2_9_21000_128.json                                      OK
+ ecmul_1-2_9_21000_96.json                                       OK
+ ecmul_1-2_9_28000_128.json                                      OK
+ ecmul_1-2_9_28000_96.json                                       OK
+ ecmul_1-3_0_21000_128.json                                      OK
+ ecmul_1-3_0_21000_64.json                                       OK
+ ecmul_1-3_0_21000_80.json                                       OK
+ ecmul_1-3_0_21000_96.json                                       OK
+ ecmul_1-3_0_28000_128.json                                      OK
+ ecmul_1-3_0_28000_64.json                                       OK
+ ecmul_1-3_0_28000_80.json                                       OK
+ ecmul_1-3_0_28000_80_Paris.json                                 OK
+ ecmul_1-3_0_28000_96.json                                       OK
+ ecmul_1-3_1_21000_128.json                                      OK
+ ecmul_1-3_1_21000_96.json                                       OK
+ ecmul_1-3_1_28000_128.json                                      OK
+ ecmul_1-3_1_28000_96.json                                       OK
+ ecmul_1-3_2_21000_128.json                                      OK
+ ecmul_1-3_2_21000_96.json                                       OK
+ ecmul_1-3_2_28000_128.json                                      OK
+ ecmul_1-3_2_28000_96.json                                       OK
+ ecmul_1-3_340282366920938463463374607431768211456_21000_128.jso OK
+ ecmul_1-3_340282366920938463463374607431768211456_21000_80.json OK
+ ecmul_1-3_340282366920938463463374607431768211456_21000_96.json OK
+ ecmul_1-3_340282366920938463463374607431768211456_28000_128.jso OK
+ ecmul_1-3_340282366920938463463374607431768211456_28000_80.json OK
+ ecmul_1-3_340282366920938463463374607431768211456_28000_96.json OK
+ ecmul_1-3_5616_21000_128.json                                   OK
+ ecmul_1-3_5616_21000_96.json                                    OK
+ ecmul_1-3_5616_28000_128.json                                   OK
+ ecmul_1-3_5616_28000_96.json                                    OK
+ ecmul_1-3_5617_21000_128.json                                   OK
+ ecmul_1-3_5617_21000_96.json                                    OK
+ ecmul_1-3_5617_28000_128.json                                   OK
+ ecmul_1-3_5617_28000_96.json                                    OK
+ ecmul_1-3_9935_21000_128.json                                   OK
+ ecmul_1-3_9935_21000_96.json                                    OK
+ ecmul_1-3_9935_28000_128.json                                   OK
+ ecmul_1-3_9935_28000_96.json                                    OK
+ ecmul_1-3_9_21000_128.json                                      OK
+ ecmul_1-3_9_21000_96.json                                       OK
+ ecmul_1-3_9_28000_128.json                                      OK
+ ecmul_1-3_9_28000_96.json                                       OK
+ ecmul_7827-6598_0_21000_128.json                                OK
+ ecmul_7827-6598_0_21000_64.json                                 OK
+ ecmul_7827-6598_0_21000_80.json                                 OK
+ ecmul_7827-6598_0_21000_96.json                                 OK
+ ecmul_7827-6598_0_28000_128.json                                OK
+ ecmul_7827-6598_0_28000_64.json                                 OK
+ ecmul_7827-6598_0_28000_80.json                                 OK
+ ecmul_7827-6598_0_28000_96.json                                 OK
+ ecmul_7827-6598_1456_21000_128.json                             OK
+ ecmul_7827-6598_1456_21000_80.json                              OK
+ ecmul_7827-6598_1456_21000_96.json                              OK
+ ecmul_7827-6598_1456_28000_128.json                             OK
+ ecmul_7827-6598_1456_28000_80.json                              OK
+ ecmul_7827-6598_1456_28000_96.json                              OK
+ ecmul_7827-6598_1_21000_128.json                                OK
+ ecmul_7827-6598_1_21000_96.json                                 OK
+ ecmul_7827-6598_1_28000_128.json                                OK
+ ecmul_7827-6598_1_28000_96.json                                 OK
+ ecmul_7827-6598_2_21000_128.json                                OK
+ ecmul_7827-6598_2_21000_96.json                                 OK
+ ecmul_7827-6598_2_28000_128.json                                OK
+ ecmul_7827-6598_2_28000_96.json                                 OK
+ ecmul_7827-6598_5616_21000_128.json                             OK
+ ecmul_7827-6598_5616_21000_96.json                              OK
+ ecmul_7827-6598_5616_28000_128.json                             OK
+ ecmul_7827-6598_5616_28000_96.json                              OK
+ ecmul_7827-6598_5617_21000_128.json                             OK
+ ecmul_7827-6598_5617_21000_96.json                              OK
+ ecmul_7827-6598_5617_28000_128.json                             OK
+ ecmul_7827-6598_5617_28000_96.json                              OK
+ ecmul_7827-6598_9935_21000_128.json                             OK
+ ecmul_7827-6598_9935_21000_96.json                              OK
+ ecmul_7827-6598_9935_28000_128.json                             OK
+ ecmul_7827-6598_9935_28000_96.json                              OK
+ ecmul_7827-6598_9_21000_128.json                                OK
+ ecmul_7827-6598_9_21000_96.json                                 OK
+ ecmul_7827-6598_9_28000_128.json                                OK
+ ecmul_7827-6598_9_28000_96.json                                 OK
+ ecpairing_bad_length_191.json                                   OK
+ ecpairing_bad_length_193.json                                   OK
+ ecpairing_empty_data.json                                       OK
+ ecpairing_empty_data_insufficient_gas.json                      OK
+ ecpairing_inputs.json                                           OK
+ ecpairing_one_point_fail.json                                   OK
+ ecpairing_one_point_insufficient_gas.json                       OK
+ ecpairing_one_point_not_in_subgroup.json                        OK
+ ecpairing_one_point_with_g1_zero.json                           OK
+ ecpairing_one_point_with_g2_zero.json                           OK
+ ecpairing_one_point_with_g2_zero_and_g1_invalid.json            OK
+ ecpairing_perturb_g2_by_curve_order.json                        OK
+ ecpairing_perturb_g2_by_field_modulus.json                      OK
+ ecpairing_perturb_g2_by_field_modulus_again.json                OK
+ ecpairing_perturb_g2_by_one.json                                OK
+ ecpairing_perturb_zeropoint_by_curve_order.json                 OK
+ ecpairing_perturb_zeropoint_by_field_modulus.json               OK
+ ecpairing_perturb_zeropoint_by_one.json                         OK
+ ecpairing_three_point_fail_1.json                               OK
+ ecpairing_three_point_match_1.json                              OK
+ ecpairing_two_point_fail_1.json                                 OK
+ ecpairing_two_point_fail_2.json                                 OK
+ ecpairing_two_point_match_1.json                                OK
+ ecpairing_two_point_match_2.json                                OK
+ ecpairing_two_point_match_3.json                                OK
+ ecpairing_two_point_match_4.json                                OK
+ ecpairing_two_point_match_5.json                                OK
+ ecpairing_two_point_oog.json                                    OK
+ ecpairing_two_points_with_one_g2_zero.json                      OK
+ pairingTest.json                                                OK
+ pointAdd.json                                                   OK
+ pointAddTrunc.json                                              OK
+ pointMulAdd.json                                                OK
+ pointMulAdd2.json                                               OK
```
OK: 135/135 Fail: 0/135 Skip: 0/135
## stZeroKnowledge2
```diff
+ ecadd_0-0_0-0_21000_0.json                                      OK
+ ecadd_0-0_0-0_21000_128.json                                    OK
+ ecadd_0-0_0-0_21000_192.json                                    OK
+ ecadd_0-0_0-0_21000_64.json                                     OK
+ ecadd_0-0_0-0_21000_80.json                                     OK
+ ecadd_0-0_0-0_21000_80_Paris.json                               OK
+ ecadd_0-0_0-0_25000_0.json                                      OK
+ ecadd_0-0_0-0_25000_128.json                                    OK
+ ecadd_0-0_0-0_25000_192.json                                    OK
+ ecadd_0-0_0-0_25000_64.json                                     OK
+ ecadd_0-0_0-0_25000_80.json                                     OK
+ ecadd_0-0_1-2_21000_128.json                                    OK
+ ecadd_0-0_1-2_21000_192.json                                    OK
+ ecadd_0-0_1-2_25000_128.json                                    OK
+ ecadd_0-0_1-2_25000_192.json                                    OK
+ ecadd_0-0_1-3_21000_128.json                                    OK
+ ecadd_0-0_1-3_25000_128.json                                    OK
+ ecadd_0-3_1-2_21000_128.json                                    OK
+ ecadd_0-3_1-2_25000_128.json                                    OK
+ ecadd_1-2_0-0_21000_128.json                                    OK
+ ecadd_1-2_0-0_21000_192.json                                    OK
+ ecadd_1-2_0-0_21000_64.json                                     OK
+ ecadd_1-2_0-0_25000_128.json                                    OK
+ ecadd_1-2_0-0_25000_192.json                                    OK
+ ecadd_1-2_0-0_25000_64.json                                     OK
+ ecadd_1-2_1-2_21000_128.json                                    OK
+ ecadd_1-2_1-2_21000_192.json                                    OK
+ ecadd_1-2_1-2_25000_128.json                                    OK
+ ecadd_1-2_1-2_25000_192.json                                    OK
+ ecadd_1-3_0-0_21000_80.json                                     OK
+ ecadd_1-3_0-0_25000_80.json                                     OK
+ ecadd_1-3_0-0_25000_80_Paris.json                               OK
+ ecadd_1145-3932_1145-4651_21000_192.json                        OK
+ ecadd_1145-3932_1145-4651_25000_192.json                        OK
+ ecadd_1145-3932_2969-1336_21000_128.json                        OK
+ ecadd_1145-3932_2969-1336_25000_128.json                        OK
+ ecadd_6-9_19274124-124124_21000_128.json                        OK
+ ecadd_6-9_19274124-124124_25000_128.json                        OK
+ ecmul_0-0_0_21000_0.json                                        OK
+ ecmul_0-0_0_21000_128.json                                      OK
+ ecmul_0-0_0_21000_40.json                                       OK
+ ecmul_0-0_0_21000_64.json                                       OK
+ ecmul_0-0_0_21000_80.json                                       OK
+ ecmul_0-0_0_21000_96.json                                       OK
+ ecmul_0-0_0_28000_0.json                                        OK
+ ecmul_0-0_0_28000_128.json                                      OK
+ ecmul_0-0_0_28000_40.json                                       OK
+ ecmul_0-0_0_28000_64.json                                       OK
+ ecmul_0-0_0_28000_80.json                                       OK
+ ecmul_0-0_0_28000_96.json                                       OK
+ ecmul_0-0_1_21000_128.json                                      OK
+ ecmul_0-0_1_21000_96.json                                       OK
+ ecmul_0-0_1_28000_128.json                                      OK
+ ecmul_0-0_1_28000_96.json                                       OK
+ ecmul_0-0_2_21000_128.json                                      OK
+ ecmul_0-0_2_21000_96.json                                       OK
+ ecmul_0-0_2_28000_128.json                                      OK
+ ecmul_0-0_2_28000_96.json                                       OK
+ ecmul_0-0_340282366920938463463374607431768211456_21000_128.jso OK
+ ecmul_0-0_340282366920938463463374607431768211456_21000_80.json OK
+ ecmul_0-0_340282366920938463463374607431768211456_21000_96.json OK
+ ecmul_0-0_340282366920938463463374607431768211456_28000_128.jso OK
+ ecmul_0-0_340282366920938463463374607431768211456_28000_80.json OK
+ ecmul_0-0_340282366920938463463374607431768211456_28000_96.json OK
+ ecmul_0-0_5616_21000_128.json                                   OK
+ ecmul_0-0_5616_21000_96.json                                    OK
+ ecmul_0-0_5616_28000_128.json                                   OK
+ ecmul_0-0_5616_28000_96.json                                    OK
+ ecmul_0-0_5617_21000_128.json                                   OK
+ ecmul_0-0_5617_21000_96.json                                    OK
+ ecmul_0-0_5617_28000_128.json                                   OK
+ ecmul_0-0_5617_28000_96.json                                    OK
+ ecmul_0-0_9935_21000_128.json                                   OK
+ ecmul_0-0_9935_21000_96.json                                    OK
+ ecmul_0-0_9935_28000_128.json                                   OK
+ ecmul_0-0_9935_28000_96.json                                    OK
+ ecmul_0-0_9_21000_128.json                                      OK
+ ecmul_0-0_9_21000_96.json                                       OK
+ ecmul_0-0_9_28000_128.json                                      OK
+ ecmul_0-0_9_28000_96.json                                       OK
+ ecmul_0-3_0_21000_128.json                                      OK
+ ecmul_0-3_0_21000_64.json                                       OK
+ ecmul_0-3_0_21000_80.json                                       OK
+ ecmul_0-3_0_21000_96.json                                       OK
+ ecmul_0-3_0_28000_128.json                                      OK
+ ecmul_0-3_0_28000_64.json                                       OK
+ ecmul_0-3_0_28000_80.json                                       OK
+ ecmul_0-3_0_28000_96.json                                       OK
+ ecmul_0-3_1_21000_128.json                                      OK
+ ecmul_0-3_1_21000_96.json                                       OK
+ ecmul_0-3_1_28000_128.json                                      OK
+ ecmul_0-3_1_28000_96.json                                       OK
+ ecmul_0-3_2_21000_128.json                                      OK
+ ecmul_0-3_2_21000_96.json                                       OK
+ ecmul_0-3_2_28000_128.json                                      OK
+ ecmul_0-3_2_28000_96.json                                       OK
+ ecmul_0-3_340282366920938463463374607431768211456_21000_128.jso OK
+ ecmul_0-3_340282366920938463463374607431768211456_21000_80.json OK
+ ecmul_0-3_340282366920938463463374607431768211456_21000_96.json OK
+ ecmul_0-3_340282366920938463463374607431768211456_28000_128.jso OK
+ ecmul_0-3_340282366920938463463374607431768211456_28000_80.json OK
+ ecmul_0-3_340282366920938463463374607431768211456_28000_96.json OK
+ ecmul_0-3_5616_21000_128.json                                   OK
+ ecmul_0-3_5616_21000_96.json                                    OK
+ ecmul_0-3_5616_28000_128.json                                   OK
+ ecmul_0-3_5616_28000_96.json                                    OK
+ ecmul_0-3_5616_28000_96_Paris.json                              OK
+ ecmul_0-3_5617_21000_128.json                                   OK
+ ecmul_0-3_5617_21000_96.json                                    OK
+ ecmul_0-3_5617_28000_128.json                                   OK
+ ecmul_0-3_5617_28000_96.json                                    OK
+ ecmul_0-3_9935_21000_128.json                                   OK
+ ecmul_0-3_9935_21000_96.json                                    OK
+ ecmul_0-3_9935_28000_128.json                                   OK
+ ecmul_0-3_9935_28000_96.json                                    OK
+ ecmul_0-3_9_21000_128.json                                      OK
+ ecmul_0-3_9_21000_96.json                                       OK
+ ecmul_0-3_9_28000_128.json                                      OK
+ ecmul_0-3_9_28000_96.json                                       OK
+ ecmul_1-2_0_21000_128.json                                      OK
+ ecmul_1-2_0_21000_64.json                                       OK
+ ecmul_1-2_0_21000_80.json                                       OK
+ ecmul_1-2_0_21000_96.json                                       OK
+ ecmul_1-2_0_28000_128.json                                      OK
+ ecmul_1-2_0_28000_64.json                                       OK
+ ecmul_1-2_0_28000_80.json                                       OK
+ ecmul_1-2_0_28000_96.json                                       OK
+ ecmul_1-2_1_21000_128.json                                      OK
+ ecmul_1-2_1_21000_96.json                                       OK
+ ecmul_1-2_1_28000_128.json                                      OK
+ ecmul_1-2_1_28000_96.json                                       OK
+ ecmul_1-2_2_21000_128.json                                      OK
+ ecmul_1-2_2_21000_96.json                                       OK
```
OK: 133/133 Fail: 0/133 Skip: 0/133
## vmArithmeticTest
```diff
+ add.json                                                        OK
+ addmod.json                                                     OK
+ arith.json                                                      OK
+ div.json                                                        OK
+ divByZero.json                                                  OK
+ exp.json                                                        OK
+ expPower2.json                                                  OK
+ expPower256.json                                                OK
+ expPower256Of256.json                                           OK
+ fib.json                                                        OK
+ mod.json                                                        OK
+ mul.json                                                        OK
+ mulmod.json                                                     OK
+ not.json                                                        OK
+ sdiv.json                                                       OK
+ signextend.json                                                 OK
+ smod.json                                                       OK
+ sub.json                                                        OK
+ twoOps.json                                                     OK
```
OK: 19/19 Fail: 0/19 Skip: 0/19
## vmBitwiseLogicOperation
```diff
+ and.json                                                        OK
+ byte.json                                                       OK
+ eq.json                                                         OK
+ gt.json                                                         OK
+ iszero.json                                                     OK
+ lt.json                                                         OK
+ not.json                                                        OK
+ or.json                                                         OK
+ sgt.json                                                        OK
+ slt.json                                                        OK
+ xor.json                                                        OK
```
OK: 11/11 Fail: 0/11 Skip: 0/11
## vmIOandFlowOperations
```diff
+ codecopy.json                                                   OK
+ gas.json                                                        OK
+ jump.json                                                       OK
+ jumpToPush.json                                                 OK
+ jumpi.json                                                      OK
+ loop_stacklimit.json                                            OK
+ loopsConditionals.json                                          OK
+ mload.json                                                      OK
+ msize.json                                                      OK
+ mstore.json                                                     OK
+ mstore8.json                                                    OK
+ pc.json                                                         OK
+ pop.json                                                        OK
+ return.json                                                     OK
+ sstore_sload.json                                               OK
```
OK: 15/15 Fail: 0/15 Skip: 0/15
## vmLogTest
```diff
+ log0.json                                                       OK
+ log1.json                                                       OK
+ log2.json                                                       OK
+ log3.json                                                       OK
+ log4.json                                                       OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## vmPerformance
```diff
  loopExp.json                                                    Skip
  loopMul.json                                                    Skip
+ performanceTester.json                                          OK
```
OK: 1/3 Fail: 0/3 Skip: 2/3
## vmTests
```diff
+ blockInfo.json                                                  OK
+ calldatacopy.json                                               OK
+ calldataload.json                                               OK
+ calldatasize.json                                               OK
+ dup.json                                                        OK
+ envInfo.json                                                    OK
+ push.json                                                       OK
+ random.json                                                     OK
+ sha3.json                                                       OK
+ suicide.json                                                    OK
+ swap.json                                                       OK
```
OK: 11/11 Fail: 0/11 Skip: 0/11
## yul
```diff
+ yul.json                                                        OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1

---TOTAL---
OK: 2705/2807 Fail: 0/2807 Skip: 102/2807
