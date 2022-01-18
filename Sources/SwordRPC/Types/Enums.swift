//
//  Enums.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

enum Event: String, Codable {
    case error = "ERROR"
    case join = "ACTIVITY_JOIN"
    case joinRequest = "ACTIVITY_JOIN_REQUEST"
    case ready = "READY"
    case spectate = "ACTIVITY_SPECTATE"
}

enum Command: String, Codable {
    case dispatch = "DISPATCH"
    case authorize = "AUTHORIZE"
    case subscribe = "SUBSCRIBE"
}

struct Response: Decodable {
    let cmd: Command
    let evt: Event
    let data: [String: String]?
}

public enum JoinReply: Int {
    case no
    case yes
    case ignore
}
