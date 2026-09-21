//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftUI

struct ConversationView: View {
    @State private var messageInput: String = ""
    @State var chatViewModel = ConversationViewModel()
    @State var navigationViewModel = NavigationViewModel()
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ScrollViewReader { proxy in
                    List(chatViewModel.conversation.messages) { message in
                        MessageBubbleView(message: message)
                    }
                    .onChange(of: chatViewModel.conversation.messages.count) {
                        if let lastMessage = chatViewModel.conversation.messages
                            .last
                        {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    HStack {
                        TextField("Enter your message..", text: $messageInput)
                            .padding(10)
                            .background(Color(.systemGray6))

                        Button(action: {
                            let textToSend = messageInput
                            messageInput = ""

                            Task {
                                await chatViewModel.sendMessage(
                                    messageInput: textToSend
                                )
                            }
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
                .navigationTitle("\(chatViewModel.conversation.title)")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            path.append(
                                Route.detail(chatViewModel.conversation)
                            )
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    navigationViewModel.destinationView(for: route)
                }
            }
        }
    }
}

#Preview {
    ConversationView()
}
