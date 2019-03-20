import
  eth/trie/db, ranges, os,
  eth/trie/backends/rocksdb_backend as rocksdb

const maxdb = 6

type
  BytesRange = Range[byte]

  MagicDB* = ref object of RootObj
    rocks: array[maxdb, rocksdb.ChainDB]
    lm: rocksdb.ChainDB

proc get*(db: MagicDB, key: openArray[byte]): seq[byte] =
  result = db.lm.get(key)
  if result.len != 0: return
  for i in 0 ..< maxdb:
    result = db.rocks[i].get(key)
    if result.len != 0: return
  
proc put*(db: MagicDB, key, value: openArray[byte]) =
  db.lm.put(key, value)

proc contains*(db: MagicDB, key: openArray[byte]): bool =
  if db.lm.contains(key): return true
  for i in 0 ..< maxdb:
    if db.rocks[i].contains(key): return true
    
proc del*(db: MagicDB, key: openArray[byte]) =
  db.lm.del(key)

proc newMagicDB*(path: string): MagicDB =
  result.new()
  for i in 0 ..< maxdb:
    result.rocks[i] = rocksdb.newChainDB("E:" / "nimbus" / "shard" & $(maxdb - i), true)
  result.lm = rocksdb.newChainDB(path & DirSep & "shard")
