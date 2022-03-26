//
//  SwordRPC.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

public class SwordRPC {
    // MARK: App Info

    public let appId: String
    public var handlerInterval: Int
    public let autoRegister: Bool

    // MARK: Technical stuff

    let pid: Int32
    var client: ConnectionClient?
    let worker: DispatchQueue
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var presence: RichPresence?

    // MARK: Event Handlers

    public weak var delegate: SwordRPCDelegate?

    public init(
        appId: String,
        handlerInterval: Int = 1000,
        autoRegister: Bool = true
    ) {
        self.appId = appId
        self.handlerInterval = handlerInterval
        self.autoRegister = autoRegister

        pid = ProcessInfo.processInfo.processIdentifier
        worker = DispatchQueue(
            label: "me.azoy.swordrpc.\(pid)",
            qos: .userInitiated
        )
        encoder.dateEncodingStrategy = .secondsSince1970
    }

    public func connect() {
        let tempDir = NSTemporaryDirectory()

        for ipcPort in 0 ..< 10 {
            let socketPath = tempDir + "discord-ipc-\(ipcPort)"
            let localClient = ConnectionClient(pipe: socketPath)
            do {
                try localClient.connect()

                // Set handlers
                localClient.textHandler = handleEvent

                client = localClient
                // Attempt handshaking
                try handshake()
            } catch {
                // If an error occurrs, we should not log it.
                // We must iterate through all 10 ports before logging.
                continue
            }

            subscribe(.join)
            subscribe(.spectate)
            subscribe(.joinRequest)
            return
        }

        print("[SwordRPC] Discord not detected")
    }

    public func setPresence(_ presence: RichPresence) {
        self.presence = presence
    }

    public func reply(to request: JoinRequest, with reply: JoinReply) {
        let json = """
        {
          "cmd": "\(
              reply == .yes ? "SEND_ACTIVITY_JOIN_INVITE" : "CLOSE_ACTIVITY_JOIN_REQUEST"
          )",
          "args": {
            "user_id": "\(request.userId)"
          }
        }
        """

        try? send(json: json)
    }
}
