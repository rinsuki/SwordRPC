//
//  Enums.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

enum Event: String {
    case error = "ERROR"
    case join = "ACTIVITY_JOIN"
    case joinRequest = "ACTIVITY_JOIN_REQUEST"
    case ready = "READY"
    case spectate = "ACTIVITY_SPECTATE"
}

public enum JoinReply: Int {
    case no
    case yes
    case ignore
}
