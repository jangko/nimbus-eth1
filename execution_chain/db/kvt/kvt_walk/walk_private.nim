# Nimbus-eth1
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or
# distributed except according to those terms.

import
  std/sets,
  ".."/[kvt_desc, kvt_layers]

# ------------------------------------------------------------------------------
# Public generic iterators
# ------------------------------------------------------------------------------

iterator walkPairsImpl*[T](
   db: KvtDbRef;                   # Database with top layer & backend filter
     ): tuple[key: seq[byte], data: seq[byte]] =
  ## Walk over all `(VertexID,VertexRef)` in the database. Note that entries
  ## are unsorted.
  var seen: HashSet[seq[byte]]
  for (key,data) in db.layersWalk seen:
    if data.isValid:
      yield (key,data)

  mixin walk

  for (key,data) in db.backend.T.walk:
    if key notin seen and data.isValid:
      yield (key,data)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
