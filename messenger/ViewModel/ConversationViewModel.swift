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
    var botMessage: Message = messsage1
    init() {
        conversation.messages.append(botMessage)
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
        let botMsg = Message(
            id: UUID(),
            text: "This is a Hardcoded response.",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
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
