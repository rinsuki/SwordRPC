//
//  Events.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

public extension SwordRPC {
    func onConnect(
        handler: @escaping (_ rpc: SwordRPC) -> Void
    ) {
        connectHandler = handler
    }

    func onDisconnect(
        handler: @escaping (_ rpc: SwordRPC, _ code: Int?, _ msg: String?) -> Void
    ) {
        disconnectHandler = handler
    }

    func onError(
        handler: @escaping (_ rpc: SwordRPC, _ code: Int, _ msg: String) -> Void
    ) {
        errorHandler = handler
    }

    func onJoinGame(
        handler: @escaping (_ rpc: SwordRPC, _ secret: String) -> Void
    ) {
        joinGameHandler = handler
    }

    func onSpectateGame(
        handler: @escaping (_ rpc: SwordRPC, _ secret: String) -> Void
    ) {
        spectateGameHandler = handler
    }

    func onJoinRequest(
        handler: @escaping (_ rpc: SwordRPC, _ request: JoinRequest, _ secret: String) -> Void
    ) {
        joinRequestHandler = handler
    }
}
