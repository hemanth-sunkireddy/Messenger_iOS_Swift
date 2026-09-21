//
//  ConversationViewModel.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation
import SwiftUI

enum ConversationState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

@Observable
class ConversationViewModel {
    var conversation: Conversation = conversationData
    var state: ConversationState = .idle

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

        state = .loading

        do {
            let botMsg = try await chatService.getBotResponse(
                history: conversation.messages
            )
            conversation.addMessage(message: botMsg)
            state = .success
        } catch {
            let errorText = error.localizedDescription
            state = .error(errorText)
        }
    }
}
