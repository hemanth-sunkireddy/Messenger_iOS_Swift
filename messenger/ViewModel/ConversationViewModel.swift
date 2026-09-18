//
//  ConversationViewModel.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation

@Observable
class ConversationViewModel {
    var conversation: Conversation
    
    init() {
        conversation = Conversation(
            id: 1,
            title: "Assistant Bot",
            messages: [],
            lastUpdated: Date()
        )

        let messsage1 = Message(
            id: 1,
            text: "Hello!",
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        let message2 = Message(
            id: 2,
            text: "Hi! How can I help you",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sending
        )

        conversation.addMessage(message: messsage1)
        conversation.addMessage(message: message2)
    }
    
    func sendMessage(messageInput: String) {
        guard !messageInput.isEmpty else { return }
        let newMsg = Message(
            id: conversation.messages.count + 1,
            text: messageInput,
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: newMsg)
        let botMsg = Message(
            id: conversation.messages.count + 1,
            text: "This is a Hardcoded response.",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: botMsg)
    }
}
