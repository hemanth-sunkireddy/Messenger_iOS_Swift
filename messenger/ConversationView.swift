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
        
        initial.addMessage(message: messsage1)
        initial.addMessage(message: message2)

        _conversation = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List(conversation.messages) { message in
                    VStack(alignment: message.sender == .user ? .trailing : .leading) {
                        Text("\(message.text)")
                            .foregroundColor(
                                message.sender == .user
                                    ? Color.white : Color.black
                            )
                            .padding(8)
                            .background(
                                message.sender == .user
                                    ? Color.blue : Color(.systemGray5)
                            )
                            .cornerRadius(12)
                        Text(
                            message.createdAt.formatted(
                                date: .omitted,
                                time: .shortened
                            )
                        )
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .frame(
                        maxWidth: .infinity,
                        alignment: message.sender == .user
                            ? .trailing : .leading
                    )
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
                            ConversationDetailView(conversation: conversation)
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
        let botMsg = Message(
            id: conversation.messages.count + 1,
            text: "This is a Hardcoded response.",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
        conversation.addMessage(message: botMsg)
        messageInput = ""
    }
}

#Preview {
    ConversationView()
}
