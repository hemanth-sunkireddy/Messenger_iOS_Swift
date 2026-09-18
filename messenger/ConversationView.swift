//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftUI

struct ConversationView: View {
    @State private var messageInput: String = ""
    @State var conversation: Conversation

    init() {
        var initial = Conversation(
            id: 1,
            title: "First Conversation",
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
        let message3 = Message(
            id: 3,
            text: "I need some assistance with my account.",
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .failed
        )

        initial.addMessage(message: messsage1)
        initial.addMessage(message: message2)
        initial.addMessage(message: message3)

        _conversation = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List(conversation.messages) { message in
                    VStack {
                        Text("\(message.text)")
                            .frame(
                                maxWidth: .infinity,
                                alignment: message.sender == .user
                                    ? .trailing : .leading
                            )
                    }
                    .listRowSeparator(.hidden)
                }
                HStack {
                    TextField("Enter your message..", text: $messageInput)
                        .padding(10)
                        .background(Color(.systemGray6))

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .disabled(messageInput.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .navigationTitle("\(conversation.title)")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            ConversationDetailView()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }
        }
    }

    private func sendMessage() {
        guard !messageInput.isEmpty else { return }
        let newMsg = Message(
            id: conversation.messages.count + 1,
            text: messageInput,
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: newMsg)
        messageInput = ""
    }
}

#Preview {
    ConversationView()
}
