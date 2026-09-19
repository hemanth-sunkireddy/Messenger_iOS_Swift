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
    private let chatService = ChatService()

    init() {
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

    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .detail(let item):
            ConversationDetailView(
                conversation: item
            )
        case .chat:
            ConversationView()
        }
    }
}
