//
//  IPCHandler.swift
//  SwiftRPC
//
//  Created by Spotlight Deveaux on 2022-01-17.
//

import Foundation
import NIOCore

final class IPCInboundHandler: ChannelInboundHandler {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = IPCPayload

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)

        // Obtain our opcode data.
        let opcodeInt = buffer.readInteger(endianness: .little, as: UInt32.self)!
        let opcode = IPCOpcode(rawValue: opcodeInt)!

        // Determine the size of our payload.
        // This is <payload size> - <opcode> - <size>.
        let size = buffer.readInteger(endianness: .little, as: UInt32.self)!
        let payloadSize = size

        // Finally, obtain our payload contents.
        // We utilize readNullTerminatedString to read to the end of this buffer.
        let payload = buffer.readString(length: Int(payloadSize))!

        print("read op \(opcode), size \(size), payload \(payload)")

        let result = IPCPayload(opcode: opcode, payload: payload)
        context.fireChannelRead(wrapInboundOut(result))
    }
}

final class IPCOutboundHandler: ChannelOutboundHandler {
    typealias OutboundIn = IPCPayload
    public typealias OutboundOut = ByteBuffer

    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        let data = unwrapOutboundIn(data)

        // Synthesize a buffer.
        var buffer = ByteBuffer()
        // Our payload's size is <payload length> + <opcode> + <size>.
        let payloadSize = data.payload.lengthOfBytes(using: .utf8)

        // Write contents.
        buffer.writeInteger(UInt32(data.opcode.rawValue), endianness: .little, as: UInt32.self)
        buffer.writeInteger(UInt32(payloadSize), endianness: .little, as: UInt32.self)
        buffer.writeString(data.payload)

        print("wrote op \(data.opcode), size \(payloadSize), payload \(data.payload)")

        context.write(wrapOutboundOut(buffer), promise: promise)
    }
}
