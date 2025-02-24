# Copyright (c) 2021-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed
# except according to those terms.

{.push raises: [].}

from eth/common import Account, Hash32

type
  SnapAccount = object
    accHash: Hash32
    accBody: Account

  SnapProof* = distinct seq[byte]
    ## RLP-coded node data, to be handled differently from a generic `Blob`

  SnapProofNodes = object
    ## Wrapper around `seq[SnapProof]` for controlling serialisation.
    nodes: seq[SnapProof]

  SnapStorage* = object
    slotHash*: Hash32
    slotData*: seq[byte]

  SnapAccountRange* = object
    accounts: seq[SnapAccount]
    proof: SnapProofNodes

  SnapStorageRanges* = object
    slotLists: seq[seq[SnapStorage]]
    proof: SnapProofNodes

  SnapByteCodes* = object
    codes: seq[seq[byte]]

  SnapTrieNodes* = object
    nodes: seq[seq[byte]]

func to*(data: seq[byte]; T: type SnapProof): T = data.T
func to*(node: SnapProof; T: type seq[byte]): T = node.T
