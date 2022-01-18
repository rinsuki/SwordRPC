//
//  RPC.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

extension SwordRPC {
    /// Sends a handshake to begin RPC interaction.
    func handshake() throws {
        let json = """
        {
          "v": 1,
          "client_id": "\(appId)"
        }
        """

        try send(json: json, opcode: .handshake)
    }

    func subscribe(_ event: String) {
        let json = """
        {
          "cmd": "SUBSCRIBE",
          "evt": "\(event)",
          "nonce": "\(UUID().uuidString)"
        }
        """

        try? send(json: json)
    }

    func handleEvent(_ payload: String) {
        var data = decode(payload)

        guard let evt = data["evt"] as? String,
              let event = Event(rawValue: evt)
        else {
            return
        }

        data = data["data"] as! [String: Any]

        switch event {
        case .error:
            let code = data["code"] as! Int
            let message = data["message"] as! String
            errorHandler?(self, code, message)
            delegate?.swordRPCDidReceiveError(self, code: code, message: message)

        case .join:
            let secret = data["secret"] as! String
            joinGameHandler?(self, secret)
            delegate?.swordRPCDidJoinGame(self, secret: secret)

        case .joinRequest:
            let requestData = data["user"] as! [String: Any]
//            let joinRequest = try! decoder.decode(
//                JoinRequest.self, from: encode(requestData)
//            )
            // TODO: Resolve
            let joinRequest = JoinRequest(avatar: "0", discriminator: "0000", userId: "0", username: "0")
            let secret = data["secret"] as! String
            joinRequestHandler?(self, joinRequest, secret)
            delegate?.swordRPCDidReceiveJoinRequest(self, request: joinRequest, secret: secret)

        case .ready:
            connectHandler?(self)
            delegate?.swordRPCDidConnect(self)
            updatePresence()

        case .spectate:
            let secret = data["secret"] as! String
            spectateGameHandler?(self, secret)
            delegate?.swordRPCDidSpectateGame(self, secret: secret)
        }
    }

    func updatePresence() {
        worker.asyncAfter(deadline: .now() + .seconds(15)) { [unowned self] in
            self.updatePresence()

            guard let presence = self.presence else {
                return
            }

            self.presence = nil

            let json = """
            {
              "cmd": "SET_ACTIVITY",
              "args": {
                "pid": \(self.pid),
                "activity": \(String(data: try! self.encoder.encode(presence), encoding: .utf8)!)
              },
              "nonce": "\(UUID().uuidString)"
            }
            """

            try? self.send(json: json)
        }
    }
}
