# nimbus-eth1
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed
# except according to those terms.

## Kvt DB -- key-value table
## =========================
##
{.push raises: [].}

import
  std/[hashes, tables],
  ./kvt_constants,
  ./kvt_desc/[desc_error]

from ./kvt_desc/desc_backend
  import BackendRef, PutHdlRef

# Not auto-exporting backend
export
  hashes, tables, kvt_constants, desc_error, PutHdlRef

type
  KvtTxRef* = ref object
    ## Transaction descriptor
    db*: KvtDbRef                     ## Database descriptor
    parent*: KvtTxRef                 ## Previous transaction
    sTab*: Table[seq[byte],seq[byte]] ## Structural data table

  KvtDbRef* = ref object of RootRef
    ## Three tier database object supporting distributed instances.
    backend*: BackendRef              ## Backend database (may well be `nil`)

    txRef*: KvtTxRef
      ## Tx holding data scheduled to be written to disk during the next
      ## `persist` call

    # Debugging data below, might go away in future
    xIdGen*: uint64
    xMap*: Table[seq[byte],uint64]    ## For pretty printing
    pAmx*: Table[uint64,seq[byte]]    ## For pretty printing

  KvtDbAction* = proc(db: KvtDbRef) {.gcsafe, raises: [].}
    ## Generic call back function/closure.

# ------------------------------------------------------------------------------
# Public helpers
# ------------------------------------------------------------------------------

func getOrVoid*(tab: Table[seq[byte],seq[byte]]; w: seq[byte]): seq[byte] =
  tab.getOrDefault(w, EmptyBlob)

func isValid*(key: seq[byte]): bool =
  key != EmptyBlob

func isValid*(tx: KvtTxRef): bool =
  tx != KvtTxRef(nil)

# ------------------------------------------------------------------------------
# Public functions, miscellaneous
# ------------------------------------------------------------------------------

# Don't put in a hash!
func hash*(db: KvtDbRef): Hash {.error.}

iterator stack*(tx: KvtTxRef): KvtTxRef =
  # Stack going from base to tx
  var frames: seq[KvtTxRef]
  var tx = tx
  while tx != nil:
    frames.add tx
    tx = tx.parent

  while frames.len > 0:
    yield frames.pop()

iterator rstack*(tx: KvtTxRef): KvtTxRef =
  var tx = tx
  # Stack in reverse order
  while tx != nil:
    yield tx
    tx = tx.parent

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
