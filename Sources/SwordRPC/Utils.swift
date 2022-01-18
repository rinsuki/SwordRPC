//
//  Utils.swift
//  SwordRPC
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

extension SwordRPC {
    /// Serializes the given data as JSON.
    func encode(_ value: Any) -> String {
        do {
            let encoded = try JSONSerialization.data(withJSONObject: value, options: [])
            return String(data: encoded, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }

    /// Decodes the given string as a JSON object.
    func decode(_ json: String) -> [String: Any] {
        decode(json.data(using: .utf8)!)
    }

    /// Decodes the given data as a JSON object.
    func decode(_ json: Data) -> [String: Any] {
        do {
            return try JSONSerialization.jsonObject(with: json, options: []) as! [String: Any]
        } catch {
            return [:]
        }
    }

    /// Serializes and sends the given object as JSON.
    func send(type: Any) throws {
        let encoded = encode(type)
        try client?.send(data: encoded)
    }

    /// Sends the given JSON string.
    func send(json: String) throws {
        try client?.send(data: json)
    }

    /// Sends the given JSON string with the given opcode.
    func send(json: String, opcode: IPCOpcode) throws {
        try client?.send(data: json, opcode: opcode)
    }
}
