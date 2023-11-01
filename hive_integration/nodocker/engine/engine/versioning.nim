# Nimbus
# Copyright (c) 2023 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

# Test versioning of the Engine API methods
import
  std/strutils,
  ./engine_spec

type
  EngineNewPayloadVersionTest* = ref object of EngineSpec

method withMainFork(cs: EngineNewPayloadVersionTest, fork: EngineFork): BaseSpec =
  var res = cs.clone()
  res.mainFork = fork
  return res

# Test modifying the ForkchoiceUpdated version on Payload Request to the previous/upcoming version
# when the timestamp payload attribute does not match the upgraded/downgraded version.
type
  ForkchoiceUpdatedOnPayloadRequestTest* = ref object of EngineSpec
    ForkchoiceUpdatedCustomizer

method withMainFork(cs: ForkchoiceUpdatedOnPayloadRequestTest, fork: EngineFork): BaseSpec =
  var res = cs.clone()
  res.mainFork = fork
  return res

method getName(cs: ForkchoiceUpdatedOnPayloadRequestTest): string =
  return "ForkchoiceUpdated Version on Payload Request: " + cs.BaseSpec.GetName()

method execute(cs: ForkchoiceUpdatedOnPayloadRequestTest, env: TestEnv): bool =
  # Wait until TTD is reached by this client
  let ok = waitFor env.clMockWaitForTTD()
  testCond ok

  env.clMock.produceSingleBlock(clmock.BlockProcessCallbacks(
    onPayloadAttributesGenerated: proc(): bool =
      var (
        payloadAttributes                    = &env.clMockLatestPayloadAttributes
        expectedStatus    test.PayloadStatus = PayloadExecutionStatus.valid
        expectedError     *int
        err               error
      )
      cs.SetEngineAPIVersionResolver(t.ForkConfig)
      testEngine = t.TestEngine.WithEngineAPIVersionResolver(cs.ForkchoiceUpdatedCustomizer)
      payloadAttributes, err = cs.GetPayloadAttributes(payloadAttributes)
      if err != nil (
        t.Fatalf("FAIL: Error getting custom payload attributes: %v", err)
      )
      expectedError, err = cs.GetExpectedError()
      if err != nil (
        t.Fatalf("FAIL: Error getting custom expected error: %v", err)
      )
      if cs.GetExpectInvalidStatus() (
        expectedStatus = PayloadExecutionStatus.invalid
      )

      r = env.engine.client.forkchoiceUpdated(env.clMockLatestForkchoice, payloadAttributes, env.clMockLatestHeader.Time)
      r.ExpectationDescription = cs.Expectation
      if expectedError != nil (
        r.expectErrorCode(*expectedError)
      else:
        r.expectNoError()
        r.expectPayloadStatus(expectedStatus)
      )
    ),
  ))
)