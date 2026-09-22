//
//  messengerApp.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftData
import SwiftUI

@main
struct messengerApp: App {
    var body: some Scene {
        WindowGroup {
            ConversationView()
        }
        .modelContainer(for: [Conversation.self, Message.self])
    }
}
