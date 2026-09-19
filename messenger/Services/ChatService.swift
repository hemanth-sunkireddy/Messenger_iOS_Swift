//
//  ChatService.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation

class HardCodedChatService: ChatServiceProtocol {
    func getInitialMessage() -> Message {
        return Message(
            id: UUID(),
            text: "Hello! How can I help you",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
    }

    func getBotResponse() -> Message {
        return Message(
            id: UUID(),
            text: "This is a response from ChatService.",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
    }
}
