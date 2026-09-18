//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftUI

struct ConversationView: View {
    @State private var messageInput: String = ""
    @State var viewModel = ConversationViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.conversation.messages.reversed()) { message in
                    MessageBubbleView(message: message)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                }
                .scaleEffect(x: 1, y: -1, anchor: .center)
                HStack {
                    TextField("Enter your message..", text: $messageInput)
                        .padding(10)
                        .background(Color(.systemGray6))

                    Button(action: {
                        viewModel.sendMessage(messageInput: messageInput)
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .disabled(
                        messageInput.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .navigationTitle("\(viewModel.conversation.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ConversationDetailView(
                            conversation: viewModel.conversation
                        )
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ConversationView()
}
