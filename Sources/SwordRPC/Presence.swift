//
//  Presence.swift
//  SwordRPC
//
//  Created by Spotlight Deveaux on 3/26/22.
//

import Foundation

public extension SwordRPC {
    /// Sets the presence for this RPC connection.
    /// The presence is guaranteed to be set within 15 seconds of call
    /// in accordance with Discord ratelimits.
    ///
    /// If the presence is set before RPC is connected, it is discarded.
    ///
    /// - Parameter presence: The presence to display.
    func setPresence(_ presence: RichPresence) {
        self.presence = presence
    }

    /// Clears the presence for this RPC connection.
    func clearPresence() {
        presence = nil

        // We send SET_ACTIVITY with no activity payload to clear our presence.
        let command = Command(cmd: .setActivity, args: [
            "pid": .int(Int(pid)),
        ])
        try? send(command)
    }

    /// Updates the presence.
    internal func updatePresence() {
        worker.asyncAfter(deadline: .now() + .seconds(15)) { [unowned self] in
            self.updatePresence()

            guard let presence = self.presence else {
                return
            }

            self.presence = nil

            let command = Command(cmd: .setActivity, args: [
                "pid": .int(Int(self.pid)),
                "activity": .activity(presence),
            ])

            try? self.send(command)
        }
    }
}
