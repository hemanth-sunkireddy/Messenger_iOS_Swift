//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftData
import SwiftUI

struct ConversationView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var messageInput: String = ""
    @State var chatViewModel: ConversationViewModel?
    @State var navigationViewModel = NavigationViewModel()
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if let viewModel = chatViewModel {
                    ScrollViewReader { proxy in
                        List(viewModel.conversation.sortedByDate()) { message in
                            MessageBubbleView(message: message)
                        }
                        .onAppear {
                            scrollToBottom(
                                proxy: proxy,
                                messages: viewModel.conversation.sortedByDate()
                            )
                        }
                        .onChange(of: viewModel.conversation.messages.count) {
                            scrollToBottom(
                                proxy: proxy,
                                messages: viewModel.conversation.sortedByDate()
                            )
                        }
                        switch viewModel.state {
                        case .loading:
                            HStack {
                                ProgressView()
                                Text("Gemma 4 is thinking...")
                                    .foregroundColor(.secondary)
                            }
                        case .error(let errorText):
                            Text(errorText)
                                .foregroundColor(.red)
                        case .idle, .success:
                            EmptyView()
                        }

                        HStack {
                            TextField(
                                "Enter your message..",
                                text: $messageInput
                            )
                            .padding(10)
                            .background(Color(.systemGray6))

                            Button(action: {
                                let textToSend = messageInput
                                messageInput = ""

                                Task {
                                    await viewModel.sendMessage(
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
                    .navigationTitle("\(viewModel.conversation.title)")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                path.append(
                                    Route.detail(viewModel.conversation)
                                )
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                    .navigationDestination(for: Route.self) { route in
                        navigationViewModel.destinationView(for: route)
                    }
                } else {
                    ProgressView()
                }
            }
            .task {
                if chatViewModel == nil {
                    chatViewModel = ConversationViewModel(
                        modelContext: modelContext
                    )
                }
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy, messages: [Message]) {
        guard let lastMessage = messages.last else { return }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ConversationView()
        .modelContainer(for: [Conversation.self, Message.self], inMemory: true)
}
