//
//  Delegate.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

public protocol SwordRPCDelegate: AnyObject {
    func swordRPCDidConnect(
        _ rpc: SwordRPC
    )

    func swordRPCDidDisconnect(
        _ rpc: SwordRPC,
        code: Int?,
        message msg: String?
    )

    func swordRPCDidReceiveError(
        _ rpc: SwordRPC,
        code: Int,
        message msg: String
    )

    func swordRPCDidJoinGame(
        _ rpc: SwordRPC,
        secret: String
    )

    func swordRPCDidSpectateGame(
        _ rpc: SwordRPC,
        secret: String
    )

    func swordRPCDidReceiveJoinRequest(
        _ rpc: SwordRPC,
        request: JoinRequest,
        secret: String
    )
}

public extension SwordRPCDelegate {
    func swordRPCDidConnect(
        _: SwordRPC
    ) {}

    func swordRPCDidDisconnect(
        _: SwordRPC,
        code _: Int?,
        message _: String?
    ) {}

    func swordRPCDidReceiveError(
        _: SwordRPC,
        code _: Int,
        message _: String
    ) {}

    func swordRPCDidJoinGame(
        _: SwordRPC,
        secret _: String
    ) {}

    func swordRPCDidSpectateGame(
        _: SwordRPC,
        secret _: String
    ) {}

    func swordRPCDidReceiveJoinRequest(
        _: SwordRPC,
        request _: JoinRequest,
        secret _: String
    ) {}
}
