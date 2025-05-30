# Nimbus
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or
# distributed except according to those terms.

import
  std/[os, strformat, times],
  chronicles,
  eth/common,
  results,
  unittest2,
  ../../execution_chain/core/chain,
  ../../execution_chain/db/ledger,
  ../replay/[pp, undump_blocks, undump_blocks_era1, xcheck],
  ./test_helpers

const
  EnableExtraLoggingControl = true
var
  logStartTime {.used.} = Time()
  logSavedEnv {.used.}: (bool,bool)

# ------------------------------------------------------------------------------
# Private helpers
# ------------------------------------------------------------------------------

proc setTraceLevel {.used.} =
  when defined(chronicles_runtime_filtering) and loggingEnabled:
    setLogLevel(LogLevel.TRACE)

proc setDebugLevel {.used.} =
  when defined(chronicles_runtime_filtering) and loggingEnabled:
    setLogLevel(LogLevel.DEBUG)

proc setErrorLevel {.used.} =
  when defined(chronicles_runtime_filtering) and loggingEnabled:
    setLogLevel(LogLevel.ERROR)

# --------------

template initLogging(noisy: bool, com: CommonRef) =
  when EnableExtraLoggingControl:
    if noisy:
      setDebugLevel()
      debug "start undumping into persistent blocks"
    logStartTime = Time()
    setErrorLevel()

proc finishLogging(com: CommonRef) =
  when EnableExtraLoggingControl:
    setErrorLevel()


template startLogging(noisy: bool; num: BlockNumber) =
  when EnableExtraLoggingControl:
    if noisy and logStartTime == Time():
      logStartTime = getTime()
      setDebugLevel()
      debug "start logging ...", blockNumber=num

when false:
  template startLogging(noisy: bool) =
    when EnableExtraLoggingControl:
      if noisy and logStartTime == Time():
        logStartTime = getTime()
        setDebugLevel()
        debug "start logging ..."

template stopLogging(noisy: bool) =
  when EnableExtraLoggingControl:
    if logStartTime != Time():
      debug "stop logging", elapsed=(getTime() - logStartTime).pp
      logStartTime = Time()
    setErrorLevel()

template stopLoggingAfter(noisy: bool; code: untyped) =
  ## Turn logging off after executing `block`
  block:
    defer: noisy.stopLogging()
    code

# ------------------------------------------------------------------------------
# Public test function
# ------------------------------------------------------------------------------

proc test_chainSyncProfilingPrint*(
    noisy = false;
    nBlocks: int;
    indent = 2;
      ) =
  if noisy:
    let info =
      if 0 < nBlocks and nBlocks < high(int): " (" & $nBlocks & " blocks)"
      else: ""
    discard info
    var blurb: seq[string]
    for s in blurb:
      if 0 < s.len: true.say "***", s, "\n"

proc test_chainSync*(
    noisy: bool;
    filePaths: seq[string];
    com: CommonRef;
    numBlocks = high(int);
    enaLogging = true;
    lastOneExtra = true;
    oldLogAlign = false;
      ): bool =
  ## Store persistent blocks from dump into chain DB
  let
    sayBlocks = 900'u64
    blockOnDb = com.db.baseTxFrame().getSavedStateBlockNumber()
    lastBlock = max(1, numBlocks).BlockNumber

  noisy.initLogging com
  defer: com.finishLogging()

  # Scan folder for `era1` files (ignoring the argument file name)
  let
    (dir, _, ext) = filePaths[0].splitFile
    files =
      if filePaths.len == 1 and ext == ".era1":
        @[dir]
      else:
        filePaths

  # If the least block is non-zero, resume at the next block
  let start = block:
    if blockOnDb == 0:
      0u64
    elif blockOnDb < lastBlock:
      noisy.say "***", "resuming at #", blockOnDb+1
      blockOnDb + 1
    else:
      noisy.say "***", "stop: sample exhausted"
      return true

  # This will enable printing the `era1` covered block ranges (if any)
  undump_blocks_era1.noisy = noisy

  var
    blocks = 0
    total = 0
    begin = toUnixFloat(getTime())
    sample = begin

  template sayPerf =
    if blocks > 0:
      total += blocks
      let done {.inject.} = toUnixFloat(getTime())
      noisy.say "", &"{blocks:3} blocks, {(done-sample):2.3}s,",
        " {(blocks.float / (done-sample)):4.3f} b/s,",
        " avg {(total.float / (done-begin)):4.3f} b/s"
      blocks = 0
      sample = done

  for w in files.undumpBlocks(least = start):
    let (fromBlock, toBlock) = (w[0].header.number, w[^1].header.number)
    if fromBlock == 0'u64:
      xCheck w[0].header == com.db.baseTxFrame().getBlockHeader(0'u64).expect("block header exists")
      continue

    # Process groups of blocks ...
    if toBlock < lastBlock:
      # Message if `[fromBlock,toBlock]` contains a multiple of `sayBlocks`
      if fromBlock + (toBlock mod sayBlocks) <= toBlock:
        if oldLogAlign:
          noisy.whisper "***",
           &"processing ...[#{fromBlock},#{toBlock}]...\n"
        else:
          sayPerf
          noisy.whisper "***",
            &"processing ...[#{fromBlock:>8},#{toBlock:>8}]..."
        if enaLogging:
          noisy.startLogging(w[0].header.number)

      noisy.stopLoggingAfter():
        let runPersistBlocksRc = com.persistBlocks(w)
        xCheck runPersistBlocksRc.isOk():
          if noisy:
            noisy.whisper "***", "Re-run with logging enabled...\n"
            setTraceLevel()
            discard com.persistBlocks(w)
      blocks += w.len
      continue

    # Last group or single block
    #
    # Make sure that the `lastBlock` is the first item of the argument batch.
    # So It might be necessary to Split off all blocks smaller than `lastBlock`
    # and execute them first. Then the next batch starts with the `lastBlock`.
    let
      pivot = lastBlock - fromBlock
      blocks9 = w[pivot .. ^1]
    doAssert lastBlock == blocks9[0].header.number

    # Process leading batch before `lastBlock` (if any)
    var dotsOrSpace = "..."
    if fromBlock < lastBlock:
      let
        blocks1 = w[0 ..< pivot]
      if oldLogAlign:
        noisy.whisper "***", &"processing ...[#{fromBlock},#{toBlock}]...\n"
      else:
        sayPerf
        noisy.whisper "***",
           &"processing {dotsOrSpace}[#{fromBlock:>8},#{(lastBlock-1):>8}]"
      let runPersistBlocks1Rc = com.persistBlocks(blocks1)
      xCheck runPersistBlocks1Rc.isOk()
      dotsOrSpace = "   "

    noisy.startLogging(blocks9[0].header.number)
    if lastOneExtra:
      let
        blocks0 = blocks9[0..0]
      if oldLogAlign:
        noisy.whisper "***",
          &"processing {dotsOrSpace}[#{fromBlock},#{lastBlock-1}]\n"
      else:
        sayPerf
        noisy.whisper "***",
          &"processing {dotsOrSpace}[#{lastBlock:>8},#{lastBlock:>8}]"
      noisy.stopLoggingAfter():
        let runPersistBlocks0Rc = com.persistBlocks(blocks0)
        xCheck runPersistBlocks0Rc.isOk()
    else:
      if oldLogAlign:
        noisy.whisper "***",
          &"processing {dotsOrSpace}[#{lastBlock},#{toBlock}]\n"
      else:
        sayPerf
        noisy.whisper "***",
          &"processing {dotsOrSpace}[#{lastBlock:>8},#{toBlock:>8}]"
      noisy.stopLoggingAfter():
        let runPersistBlocks9Rc = com.persistBlocks(blocks9)
        xCheck runPersistBlocks9Rc.isOk()
    break
  if not oldLogAlign:
    sayPerf

  true

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
