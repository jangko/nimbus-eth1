# Nimbus
# Copyright (c) 2018 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
#    http://www.apache.org/licenses/LICENSE-2.0)
#  * MIT license ([LICENSE-MIT](LICENSE-MIT) or
#    http://opensource.org/licenses/MIT)
# at your option. This file may not be copied, modified, or distributed except
# according to those terms.

##
## Snapshot Processor for Clique PoA Consensus Protocol
## ====================================================
##
## For details see
## `EIP-225 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-225.md>`_
## and
## `go-ethereum <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-225.md>`_
##

import
  std/[algorithm, sequtils, strutils, tables, times],
  ../clique_cfg,
  ../clique_defs,
  ./ballot,
  ./snapshot_desc,
  chronicles,
  eth/[common, rlp],
  stew/results

{.push raises: [Defect].}

logScope:
  topics = "clique PoA snapshot-apply"

# ------------------------------------------------------------------------------
# Private helpers, pretty printing
# ------------------------------------------------------------------------------

proc say(s: Snapshot; v: varargs[string,`$`]) {.inline.} =
  discard
  # uncomment body to enable
  s.cfg.say v

proc pp(a: openArray[BlockHeader]; first, last: int): string {.inline.} =
  result = "["
  var
    n = last - first
    q = toSeq(a)
  if last < first:
    q = a.reversed(last, first)
    n = q.len
  if 5 < n:
    result &= toSeq(q[0 .. 2]).mapIt("#" & $it.blockNumber).join(", ")
    result &= " .." & $n &  ".. #" & $q[n-1].blockNumber
  else:
    result &= toSeq(q[0 ..< n]).mapIt("#" & $it.blockNumber).join(", ")
  result &= "]"

# ------------------------------------------------------------------------------
# Private functions
# ------------------------------------------------------------------------------

template pairWalkIj(first, last: int; offTop: Positive; code: untyped) =
  if first <= last:
    for n in first .. last - offTop:
      let
        i {.inject.} = n
        j {.inject.} = n + 1
      code
  else:
    for n in first.countdown(last + offTop):
      let
        i {.inject.} = n
        j {.inject.} = n - 1
      code

template doWalkIt(first, last: int; code: untyped) =
  if first <= last:
    for n in first .. last:
      let it {.inject.} = n
      code
  else:
    for n in first.countdown(last):
      let it {.inject.} = n
      code

# ------------------------------------------------------------------------------
# Public functions
# ------------------------------------------------------------------------------

# clique/snapshot.go(185): func (s *Snapshot) apply(headers [..]
proc snapshotApplySeq*(s: Snapshot; headers: var seq[BlockHeader],
                       first, last: int): CliqueOkResult
                         {.gcsafe, raises: [Defect,CatchableError].} =
  ## Initialises an authorization snapshot `snap` by applying the `headers`
  ## to the argument snapshot desciptor `s`.

  s.say "applySnapshot begin #", s.blockNumber, " + ", headers.pp(first, last)

  # Sanity check that the headers can be applied
  if headers[first].blockNumber != s.blockNumber + 1:
    return err((errInvalidVotingChain,""))
  # clique/snapshot.go(191): for i := 0; i < len(headers)-1; i++ {
  first.pairWalkIj(last, 1):
    if headers[j].blockNumber != headers[i].blockNumber+1:
      return err((errInvalidVotingChain,""))

  # Iterate through the headers and create a new snapshot
  let
    start = getTime()
  var
    logged = start

  # clique/snapshot.go(206): for i, header := range headers [..]
  first.doWalkIt(last):
    let
      # headersIndex => also used for logging at the end of this loop
      headersIndex = it
      header = headers[headersIndex]
      number = header.blockNumber

    s.say "applySnapshot processing #", number

    # Remove any votes on checkpoint blocks
    if (number mod s.cfg.epoch) == 0:
      # Note that the correctness of the authorised accounts list is verified in
      #   clique/clique.verifyCascadingFields(),
      #   see clique/clique.go(355): if number%c.config.Epoch == 0 {
      # This means, the account list passed with the epoch header is verified
      # to be the same as the one we already have.
      #
      # clique/snapshot.go(210): snap.Votes = nil
      s.ballot.flushVotes
      s.say "applySnapshot epoch => reset, state=", s.pp(41)

    # Delete the oldest signer from the recent list to allow it signing again
    block:
      let limit = s.ballot.authSignersThreshold.u256
      if limit <= number:
        s.recents.del(number - limit)

    # Resolve the authorization key and check against signers
    let signer = ? s.cfg.ecRecover(header)
    #s.say "applySnapshot signer=", s.pp(signer)

    if not s.ballot.isAuthSigner(signer):
      s.say "applySnapshot signer not authorised => fail ", s.pp(29)
      return err((errUnauthorizedSigner,""))

    for recent in s.recents.values:
      if recent == signer:
        s.say "applySnapshot signer recently seen ", s.pp(signer)
        echo "+++ applySnapshot #", header.blockNumber, " err=errRecentlySigned"
        return err((errRecentlySigned,""))
    s.recents[number] = signer

    # Header authorized, discard any previous vote from the signer
    # clique/snapshot.go(233): for i, vote := range snap.Votes {
    s.ballot.delVote(signer = signer, address = header.coinbase)

    # Tally up the new vote from the signer
    # clique/snapshot.go(244): var authorize bool
    var authOk = false
    if header.nonce == NONCE_AUTH:
      authOk = true
    elif header.nonce != NONCE_DROP:
      return err((errInvalidVote,""))
    let vote = Vote(address:     header.coinbase,
                    signer:      signer,
                    blockNumber: number,
                    authorize:   authOk)
    #s.say "applySnapshot calling addVote ", s.pp(vote)
    # clique/snapshot.go(253): if snap.cast(header.Coinbase, authorize) {
    s.ballot.addVote(vote)

    # clique/snapshot.go(269): if limit := uint64(len(snap.Signers)/2 [..]
    if s.ballot.isAuthSignersListShrunk:
      # Signer list shrunk, delete any leftover recent caches
      let limit = s.ballot.authSignersThreshold.u256
      if limit <= number:
        # Pop off least block number from the list
        let item = number - limit
        s.say "will delete recent item #", item, " (", number, "-", limit,
          ") from recents={", s.pp(s.recents), "}"
        s.recents.del(item)

    #s.say "applySnapshot state=", s.pp(25)

    # If we're taking too much time (ecrecover), notify the user once a while
    if s.cfg.logInterval < getTime() - logged:
      info "Reconstructing voting history",
        processed = headersIndex,
        total = headers.len,
        elapsed = getTime() - start
      logged = getTime()

  let sinceStart = getTime() - start
  if s.cfg.logInterval < sinceStart:
    info "Reconstructed voting history",
      processed = headers.len,
      elapsed = sinceStart

  # clique/snapshot.go(303): snap.Number += uint64(len(headers))
  doAssert headers[last].blockNumber == s.blockNumber+(1+(last-first).abs).u256
  s.blockNumber = headers[last].blockNumber
  s.blockHash = headers[last].blockHash

  s.say "applySnapshot ok"
  ok()


proc snapshotApply*(s: Snapshot; headers: var seq[BlockHeader]): CliqueOkResult
                   {.gcsafe, raises: [Defect,CatchableError].} =
  if headers.len == 0:
    return ok()
  s.snapshotApplySeq(headers, 0, headers.len - 1)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------