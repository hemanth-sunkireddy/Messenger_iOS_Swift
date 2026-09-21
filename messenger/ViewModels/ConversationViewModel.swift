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

    init(chatService: ChatServiceProtocol = OllamaChatService()) {
        self.chatService = chatService

        let initialMsg = chatService.getInitialMessage()
        conversation.messages.append(initialMsg)
    }

    func sendMessage(messageInput: String) async {
        guard !messageInput.isEmpty else { return }

        let userMsg = Message(
            id: UUID(),
            text: messageInput,
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: userMsg)

        do {
            let botMsg = try await chatService.getBotResponse(
                history: conversation.messages
            )
            conversation.addMessage(message: botMsg)
        } catch {
            let errorMsg = Message(
                id: UUID(),
                text: "Failed to get response from Gemma 4.",
                sender: .assistant,
                createdAt: Date(),
                deliveryStatus: .failed
            )
            conversation.addMessage(message: errorMsg)
        }
    }
}
