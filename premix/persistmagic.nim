# use this module to quickly populate db with data from geth/parity

import
  eth/[common, rlp], stint, byteutils, nimcrypto,
  chronicles, downloader, configuration, magicdb

import
  eth/trie/[hexary, db, trie_defs],
  ../nimbus/db/[storage_types, db_chain],
  ../nimbus/[genesis, utils],
  ../nimbus/p2p/chain, ../nimbus/errors

const
  manualCommit = false

template persistToDb(db: MagicDB, body: untyped) =
  when manualCommit:
    if not db.txBegin(): assert(false)
  body
  when manualCommit:
    if not db.txCommit(): assert(false)

proc main() =
  let conf = getConfiguration()
  let db = newMagicDb(conf.dataDir)
  let trieDB = trieDB db
  let chainDB = newBaseChainDB(trieDB, false)

  # move head to block number ...
  if conf.head != 0.u256:
    var parentBlock = requestBlock(conf.head)
    chainDB.setHead(parentBlock.header)

  if canonicalHeadHashKey().toOpenArray notin trieDB:
    persistToDb(db):
      initializeEmptyDb(chainDB)
    assert(canonicalHeadHashKey().toOpenArray in trieDB)

  var head = chainDB.getCanonicalHead()
  var blockNumber = head.blockNumber + 1
  var chain = newChain(chainDB)

  let numBlocksToCommit = conf.numCommits

  var headers = newSeqOfCap[BlockHeader](numBlocksToCommit)
  var bodies  = newSeqOfCap[BlockBody](numBlocksToCommit)
  var one     = 1.u256

  var numBlocks = 0
  var counter = 0

  while true:
    var thisBlock = requestBlock(blockNumber)

    headers.add thisBlock.header
    bodies.add thisBlock.body
    stdout.write("REQUEST HEADER: ", $blockNumber, " txs: ", $thisBlock.body.transactions.len, "\n")

    inc numBlocks
    blockNumber += one

    if numBlocks == numBlocksToCommit:
      persistToDb(db):
        if chain.persistBlocks(headers, bodies) != ValidationResult.OK:
          raise newException(ValidationError, "Error when validating blocks")
      numBlocks = 0
      headers.setLen(0)
      bodies.setLen(0)

    inc counter
    if conf.maxBlocks != 0 and counter >= conf.maxBlocks:
      break

  if numBlocks > 0:
    persistToDb(db):
      if chain.persistBlocks(headers, bodies) != ValidationResult.OK:
        raise newException(ValidationError, "Error when validating blocks")

when isMainModule:
  var message: string

  ## Processing command line arguments
  if processArguments(message) != Success:
    echo message
    quit(QuitFailure)
  else:
    if len(message) > 0:
      echo message
      quit(QuitSuccess)

  try:
    main()
  except:
    echo getCurrentExceptionMsg()
