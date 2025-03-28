# Fluffy
# Copyright (c) 2022-2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# This is a PoC of how execution block headers in the Portal history network
# could be proven to be part of the canonical chain by means of a proof that
# exists out a chain of proofs.
#
# To verify this proof you need access to the BeaconState field
# historical_roots and the block hash of the execution block.
#
# The chain traverses from proving that the block hash is the one of the
# ExecutionPayload in the BeaconBlockBody, to proving that this BeaconBlockBody
# is the one that is rooted in the BeaconBlockHeader, to proving that this
# BeaconBlockHeader is rooted in the historical_roots.
#
# TODO: The middle proof is perhaps a bit silly as it doesn't win much space
# compared to just providing the BeaconHeader.
#
# Requirements:
#
# For building the proofs:
# - Node that has access to all the beacon chain data (state and blocks) and
# - it will be required to rebuild the HistoricalBatches.
#
# For verifying the proofs:
# - As mentioned, the historical_roots field of the state is required. This
# is currently in no way available over any of the consensus layer libp2p
# protocols. Thus a light client cannot really be build using these proofs,
# which makes it rather useless for now.
# - The historical_roots could be put available on the network together with
# a proof against the right state root. An example of this can be seen in
# ./fluffy/network/history/experimental/beacon_chain_historical_roots.nim
#
# Caveat:
#
# Roots in historical_roots are only added every `SLOTS_PER_HISTORICAL_ROOT`
# slots. Recent blocks that are not part of a historical_root cannot be proven
# through this mechanism. They need to be directly looked up in the block_roots
# BeaconState field.
#
# Alternative:
#
# This PoC is written with the idea of keeping execution BlockHeaders and
# BlockBodies available in the Portal history network in the same way post-merge
# as it is pre-merge. One could also simply decide to store the BeaconBlocks or
# BeaconBlockHeaders and BeaconBlockBodies directly. And get the execution
# payloads from there. This would require only 1 (or two, depending on what you
# store) of the proofs and might be more convenient if you want to / need to
# store the beacon data also on the network. It would require some rebuilding
# the structure of the Execution BlockHeader.
#
# Alternative ii:
#
# Verifying a specific block could also be done by making use of the
# LightClientUpdates. Picking the closest update, and walking back blocks from
# that block to the specific block. How much data is required to download would
# depend on the location of the block, but it could be quite significant.
# Of course, this again could be thrown in some accumulator, but that would
# then be required to be stored on the state to make it easy verifiable.
# A PoC of this process would be nice and it could be more useful for a system
# like the Nimbus verified proxy.
#
#
# The usage of this PoC can be seen in
# ./fluffy/tests/test_beacon_chain_block_proof.nim
#
# TODO: Probably needs to make usage of forks instead of just bellatrix.
#

{.push raises: [].}

import
  results,
  ssz_serialization,
  ssz_serialization/[proofs, merkleization],
  beacon_chain/spec/eth2_ssz_serialization,
  beacon_chain/spec/ssz_codec,
  beacon_chain/spec/datatypes/bellatrix,
  beacon_chain/spec/forks,
  ./block_proof_common

export block_proof_common, ssz_codec

type
  BeaconBlockProofHistoricalRoots* = array[14, Digest]

  BlockProofHistoricalRoots* = object
    # Total size (14 + 1 + 11) * 32 bytes + 4 bytes = 836 bytes
    beaconBlockProof*: BeaconBlockProofHistoricalRoots
    beaconBlockRoot*: Digest
    executionBlockProof*: ExecutionBlockProof
    slot*: Slot

  HistoricalRoots* = HashList[Digest, Limit HISTORICAL_ROOTS_LIMIT]

func getHistoricalRootsIndex*(slot: Slot): uint64 =
  slot div SLOTS_PER_HISTORICAL_ROOT

func getHistoricalRootsIndex*(blockHeader: BeaconBlockHeader): uint64 =
  getHistoricalRootsIndex(blockHeader.slot)

template `[]`(x: openArray[Eth2Digest], chunk: Limit): Eth2Digest =
  # Nim 2.0 requires arrays to be indexed by the same type they're declared with.
  # Both HistoricalBatch.block_roots and HistoricalBatch.state_roots
  # are declared with uint64. But `Limit = int64`.
  # Looks like this template can be used as a workaround.
  # See https://github.com/status-im/nimbus-eth1/pull/2384
  x[chunk.uint64]

# Builds proof to be able to verify that a BeaconBlock root is part of the
# HistoricalBatch for given root.
func buildProof*(
    batch: HistoricalBatch, blockRootIndex: uint64
): Result[BeaconBlockProofHistoricalRoots, string] =
  # max list size * 2 is start point of leaves
  let gIndex = GeneralizedIndex(2 * SLOTS_PER_HISTORICAL_ROOT + blockRootIndex)

  var proof: BeaconBlockProofHistoricalRoots
  ?batch.build_proof(gIndex, proof)

  ok(proof)

func buildProof*(
    batch: HistoricalBatch,
    beaconBlock: bellatrix.TrustedBeaconBlock | bellatrix.BeaconBlock,
): Result[BlockProofHistoricalRoots, string] =
  let
    blockRootIndex = getBlockRootsIndex(beaconBlock)
    executionBlockProof = ?beaconBlock.buildProof()
    beaconBlockProof = ?batch.buildProof(blockRootIndex)

  ok(
    BlockProofHistoricalRoots(
      beaconBlockProof: beaconBlockProof,
      beaconBlockRoot: hash_tree_root(beaconBlock),
      executionBlockProof: executionBlockProof,
      slot: beaconBlock.slot,
    )
  )

func verifyProof*(
    blockHeaderRoot: Digest,
    proof: BeaconBlockProofHistoricalRoots,
    historicalRoot: Digest,
    blockRootIndex: uint64,
): bool =
  let gIndex = GeneralizedIndex(2 * SLOTS_PER_HISTORICAL_ROOT + blockRootIndex)

  verify_merkle_multiproof(@[blockHeaderRoot], proof, @[gIndex], historicalRoot)

func verifyProof*(
    historical_roots: HistoricalRoots,
    proof: BlockProofHistoricalRoots,
    blockHash: Digest,
): bool =
  let
    historicalRootsIndex = getHistoricalRootsIndex(proof.slot)
    blockRootIndex = getBlockRootsIndex(proof.slot)

  blockHash.verifyProof(proof.executionBlockProof, proof.beaconBlockRoot) and
    proof.beaconBlockRoot.verifyProof(
      proof.beaconBlockProof, historical_roots[historicalRootsIndex], blockRootIndex
    )
