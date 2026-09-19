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
        id: UUID(),
        title: "First Conversation",
        messages: [
            Message(
                id: UUID(),
                text: "Hello!",
                sender: .user,
                createdAt: Date(),
                deliveryStatus: .sent
            ),
        ],
        lastUpdated: Date()
    )

    ConversationDetailView(conversation: conversation)
}
