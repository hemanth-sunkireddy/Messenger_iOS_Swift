//
//  ConversationDetailView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 18/09/26.
//

import SwiftUI

struct ConversationDetailView: View {
    let conversation: Conversation
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(conversation.title)
                .font(.title)

            Text("Total Messages: \(conversation.messageCount())")

            if let lastMessage = conversation.getLatestMessage() {
                Text("Last Message: \(lastMessage.text)")
            }

            Text("User Messages: \(conversation.filter(by: .user).count)")

            Spacer()
        }
    }
}

#Preview {
    let conversation = Conversation(
        id: 1,
        title: "First Conversation",
        messages: [
            Message(
                id: 1,
                text: "Hello!",
                sender: .user,
                createdAt: Date(),
                deliveryStatus: .sent
            ),
            Message(
                id: 2,
                text: "Hi! How can I help you",
                sender: .assistant,
                createdAt: Date(),
                deliveryStatus: .sending
            ),
        ],
        lastUpdated: Date()
    )

    ConversationDetailView(conversation: conversation)
}
