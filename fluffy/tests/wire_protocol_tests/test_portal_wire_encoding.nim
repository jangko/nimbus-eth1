# Nimbus
# Copyright (c) 2021-2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.used.}

import
  unittest2,
  stint,
  stew/byteutils,
  results,
  eth/p2p/discoveryv5/enr,
  ../../network/wire/messages

# According to test vectors:
# https://github.com/ethereum/portal-network-specs/blob/master/portal-wire-test-vectors.md

suite "Portal Wire Protocol Message Encodings":
  test "Ping Request":
    let
      enrSeq = 1'u64
      # Can be any custom payload, testing with meaningless string of bytes.
      customPayload = ByteList[1100].init(@[byte 0x01, 0x02, 0x03, 0x04])
      p = PingMessage(enrSeq: enrSeq, payload_type: 42'u16, payload: customPayload)

    let encoded = encodeMessage(p)
    check encoded.toHex == "0001000000000000002a000e00000001020304"
    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == ping
      message.ping.enrSeq == enrSeq
      message.ping.payload_type == 42'u16
      message.ping.payload == customPayload

  test "Pong Response":
    let
      enrSeq = 1'u64
      # Can be any custom payload, testing with meaningless string of bytes.
      customPayload = ByteList[1100].init(@[byte 0x01, 0x02, 0x03, 0x04])
      p = PongMessage(enrSeq: enrSeq, payload_type: 42'u16, payload: customPayload)

    let encoded = encodeMessage(p)
    check encoded.toHex == "0101000000000000002a000e00000001020304"
    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == pong
      message.pong.enrSeq == enrSeq
      message.pong.payload_type == 42'u16
      message.pong.payload == customPayload

  test "FindNodes Request":
    let
      distances = List[uint16, 256](@[0x0100'u16, 0x00ff'u16])
      fn = FindNodesMessage(distances: distances)

    let encoded = encodeMessage(fn)
    check encoded.toHex == "02040000000001ff00"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == findNodes
      message.findNodes.distances == distances

  test "Nodes Response - empty enr list":
    let
      total = 0x1'u8
      n = NodesMessage(total: total)

    let encoded = encodeMessage(n)
    check encoded.toHex == "030105000000"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == nodes
      message.nodes.total == total
      message.nodes.enrs.len() == 0

  test "Nodes Response - enrs":
    let
      res1 = Record.fromURI(
        "enr:-HW4QBzimRxkmT18hMKaAL3IcZF1UcfTMPyi3Q1pxwZZbcZVRI8DC5infUAB_UauARLOJtYTxaagKoGmIjzQxO2qUygBgmlkgnY0iXNlY3AyNTZrMaEDymNMrg1JrLQB2KTGtv6MVbcNEVv0AHacwUAPMljNMTg"
      )
      res2 = Record.fromURI(
        "enr:-HW4QNfxw543Ypf4HXKXdYxkyzfcxcO-6p9X986WldfVpnVTQX1xlTnWrktEWUbeTZnmgOuAY_KUhbVV1Ft98WoYUBMBgmlkgnY0iXNlY3AyNTZrMaEDDiy3QkHAxPyOgWbxp5oF1bDdlYE6dLCUUp8xfVw50jU"
      )
    check:
      res1.isOk()
      res2.isOk()

    let
      e1 = res1.value
      e2 = res2.value
      total = 0x1'u8
      n = NodesMessage(
        total: total,
        enrs:
          List[ByteList[2048], 32](@[ByteList[2048](e1.raw), ByteList[2048](e2.raw)]),
      )

    let encoded = encodeMessage(n)
    check encoded.toHex ==
      "030105000000080000007f000000f875b8401ce2991c64993d7c84c29a00bdc871917551c7d330fca2dd0d69c706596dc655448f030b98a77d4001fd46ae0112ce26d613c5a6a02a81a6223cd0c4edaa53280182696482763489736563703235366b31a103ca634cae0d49acb401d8a4c6b6fe8c55b70d115bf400769cc1400f3258cd3138f875b840d7f1c39e376297f81d7297758c64cb37dcc5c3beea9f57f7ce9695d7d5a67553417d719539d6ae4b445946de4d99e680eb8063f29485b555d45b7df16a1850130182696482763489736563703235366b31a1030e2cb74241c0c4fc8e8166f1a79a05d5b0dd95813a74b094529f317d5c39d235"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == nodes
      message.nodes.total == total
      message.nodes.enrs.len() == 2
      message.nodes.enrs[0] == ByteList[2048](e1.raw)
      message.nodes.enrs[1] == ByteList[2048](e2.raw)

  test "FindContent Request":
    const contentKeyString = "0x706f7274616c"
    let
      contentKey = ContentKeyByteList.init(hexToSeqByte(contentKeyString))
      fc = FindContentMessage(contentKey: contentKey)

    let encoded = encodeMessage(fc)
    check encoded.toHex == "0404000000706f7274616c"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == findContent
      message.findContent.contentKey == contentKey

  test "Content Response - connection id":
    let
      connectionId = Bytes2([byte 0x01, 0x02])
      c =
        ContentMessage(contentMessageType: connectionIdType, connectionId: connectionId)

    let encoded = encodeMessage(c)
    check encoded.toHex == "05000102"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == MessageKind.content
      message.content.contentMessageType == connectionIdType
      message.content.connectionId == connectionId

  test "Content Response - content payload":
    const contentString = "0x7468652063616b652069732061206c6965"
    let
      content = ByteList[2048](hexToSeqByte(contentString))
      c = ContentMessage(contentMessageType: contentType, content: content)

    let encoded = encodeMessage(c)
    check encoded.toHex == "05017468652063616b652069732061206c6965"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == MessageKind.content
      message.content.contentMessageType == contentType
      message.content.content == content

  test "Content Response - enrs":
    let
      res1 = Record.fromURI(
        "enr:-HW4QBzimRxkmT18hMKaAL3IcZF1UcfTMPyi3Q1pxwZZbcZVRI8DC5infUAB_UauARLOJtYTxaagKoGmIjzQxO2qUygBgmlkgnY0iXNlY3AyNTZrMaEDymNMrg1JrLQB2KTGtv6MVbcNEVv0AHacwUAPMljNMTg"
      )
      res2 = Record.fromURI(
        "enr:-HW4QNfxw543Ypf4HXKXdYxkyzfcxcO-6p9X986WldfVpnVTQX1xlTnWrktEWUbeTZnmgOuAY_KUhbVV1Ft98WoYUBMBgmlkgnY0iXNlY3AyNTZrMaEDDiy3QkHAxPyOgWbxp5oF1bDdlYE6dLCUUp8xfVw50jU"
      )
    check:
      res1.isOk()
      res2.isOk()

    let
      e1 = res1.value
      e2 = res2.value
      enrs = List[ByteList[2048], 32](@[ByteList[2048](e1.raw), ByteList[2048](e2.raw)])
      c = ContentMessage(contentMessageType: enrsType, enrs: enrs)

    let encoded = encodeMessage(c)
    check encoded.toHex ==
      "0502080000007f000000f875b8401ce2991c64993d7c84c29a00bdc871917551c7d330fca2dd0d69c706596dc655448f030b98a77d4001fd46ae0112ce26d613c5a6a02a81a6223cd0c4edaa53280182696482763489736563703235366b31a103ca634cae0d49acb401d8a4c6b6fe8c55b70d115bf400769cc1400f3258cd3138f875b840d7f1c39e376297f81d7297758c64cb37dcc5c3beea9f57f7ce9695d7d5a67553417d719539d6ae4b445946de4d99e680eb8063f29485b555d45b7df16a1850130182696482763489736563703235366b31a1030e2cb74241c0c4fc8e8166f1a79a05d5b0dd95813a74b094529f317d5c39d235"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == MessageKind.content
      message.content.contentMessageType == enrsType
      message.content.enrs.len() == 2
      message.content.enrs[0] == ByteList[2048](e1.raw)
      message.content.enrs[1] == ByteList[2048](e2.raw)

  test "Content Response - empty enrs":
    let
      enrs = List[ByteList[2048], 32].init(@[])
      c = ContentMessage(contentMessageType: enrsType, enrs: enrs)
    let encoded = encodeMessage(c)
    check encoded.toHex == "0502"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()
    let message = decoded.get()
    check:
      message.kind == MessageKind.content
      message.content.contentMessageType == enrsType
      message.content.enrs.len() == 0

  test "Offer Request":
    let
      contentKeys =
        ContentKeysList(List(@[ContentKeyByteList(@[byte 0x01, 0x02, 0x03])]))
      o = OfferMessage(contentKeys: contentKeys)

    let encoded = encodeMessage(o)
    check encoded.toHex == "060400000004000000010203"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == offer
      message.offer.contentKeys == contentKeys

  test "Accept Response":
    let
      contentKeys = ContentKeysAcceptList.init(@[byte 0, 1, 2, 3, 4, 5, 1, 1])
      connectionId = Bytes2([byte 0x01, 0x02])
      a = AcceptMessage(connectionId: connectionId, contentKeys: contentKeys)

    let encoded = encodeMessage(a)
    check encoded.toHex == "070102060000000001020304050101"

    let decoded = decodeMessage(encoded)
    check decoded.isOk()

    let message = decoded.get()
    check:
      message.kind == MessageKind.accept
      message.accept.connectionId == connectionId
      message.accept.contentKeys == contentKeys
