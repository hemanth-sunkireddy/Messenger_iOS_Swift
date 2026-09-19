//
//  ConversationViewModel.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation
import SwiftUI

@Observable
class ConversationViewModel {
    var conversation: Conversation = conversationData
    private let chatService: ChatServiceProtocol

    init(chatService: ChatServiceProtocol = HardCodedChatService()) {
        self.chatService = chatService

        let initialMsg = chatService.getInitialMessage()
        conversation.messages.append(initialMsg)
    }

    func sendMessage(messageInput: String) {
        guard !messageInput.isEmpty else { return }
        let newMsg = Message(
            id: UUID(),
            text: messageInput,
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: newMsg)

        let botMsg = chatService.getBotResponse()
        conversation.addMessage(message: botMsg)
    }
}
