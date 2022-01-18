//
//  Responses.swift
//  
//
//  Created by Spotlight Deveaux on 2022-01-17.
//

import Foundation

struct Handshake: Encodable {
    let version: Int
    let clientId: String
    
    enum CodingKeys: String, CodingKey {
        case version = "v"
        case clientId = "client_id"
    }
}

struct GenericResponse: Encodable {
    let cmd: Command
    let evt: Event
    let nonce: String = UUID().uuidString
}
