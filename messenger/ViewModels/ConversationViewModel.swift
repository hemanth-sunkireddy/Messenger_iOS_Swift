//
//  ConversationViewModel.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation
import OSLog
import SwiftData
import SwiftUI

enum ConversationState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

@Observable
class ConversationViewModel {
    var conversation: Conversation
    var state: ConversationState = .idle

    private let chatService: ChatServiceProtocol
    private var modelContext: ModelContext?

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "messenger",
        category: "ConversationViewModel"
    )

    init(
        modelContext: ModelContext? = nil,
        chatService: ChatServiceProtocol = OllamaChatService()
    ) {
        self.chatService = chatService
        self.modelContext = modelContext
        self.conversation = Conversation()

        logger.info("Initializing ConversationViewModel")

        if let context = modelContext {
            loadFromLocalStorage(context: context)
        } else {
            logger.warning(
                "Initialized ConversationViewModel without ModelContext"
            )
        }
    }

    func sendMessage(messageInput: String) async {
        let trimmed = messageInput.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmed.isEmpty else {
            logger.debug("Attempted to send an empty message. Aborting.")
            return
        }

        logger.info("Sending message: \(trimmed, privacy: .private)")

        let userMsg = Message(
            id: UUID(),
            text: trimmed,
            sender: .user,
            createdAt: Date(),
            deliveryStatus: .sent
        )

        conversation.addMessage(message: userMsg)
        saveMessageToLocalStorage(userMsg)

        state = .loading

        do {
            logger.info("Requesting bot response from chat service")
            let botMsg = try await chatService.getBotResponse(
                history: conversation.messages
            )

            conversation.addMessage(message: botMsg)
            saveMessageToLocalStorage(botMsg)

            state = .success
            logger.info("Successfully received and saved bot response")
        } catch {
            let errorText = error.localizedDescription
            logger.error(
                "Failed to get bot response: \(errorText, privacy: .public)"
            )
            state = .error(errorText)
        }
    }

    func loadFromLocalStorage(context: ModelContext) {
        self.modelContext = context
        logger.info("Loading conversation from local storage")

        if let storeURL = context.container.configurations.first?.url {
            logger.info(
                "SwiftData SQLite URL: \(storeURL.path, privacy: .public)"
            )
        }

        let allConversationsDescriptor = FetchDescriptor<Conversation>()

        do {
            let allConversations = try context.fetch(allConversationsDescriptor)
            logger.info(
                "Found \(allConversations.count) total conversation(s) in database:"
            )
            for (index, conv) in allConversations.enumerated() {
                logger.info(
                    "  [\(index + 1)] ID: \(conv.id), Title: \(conv.title), Messages Count: \(conv.messages.count), Last Updated: \(conv.lastUpdated)"
                )
            }

            var recentDescriptor = FetchDescriptor<Conversation>(
                sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
            )
            recentDescriptor.fetchLimit = 1

            if let existingConversation = try context.fetch(recentDescriptor)
                .first
            {
                self.conversation = existingConversation
                logger.info(
                    "Loaded active conversation with \(existingConversation.messages.count) message(s)"
                )
            } else {
                logger.info(
                    "No existing conversation found. Creating new conversation."
                )
                let newConversation = Conversation()
                let initialMsg = chatService.getInitialMessage()

                context.insert(newConversation)
                context.insert(initialMsg)
                newConversation.messages.append(initialMsg)

                try context.save()
                self.conversation = newConversation
                logger.info(
                    "Successfully created and saved initial conversation"
                )
            }
        } catch {
            logger.error(
                "Failed to fetch/save conversation in local storage: \(error.localizedDescription, privacy: .public)"
            )
        }
    }

    private func saveMessageToLocalStorage(_ message: Message) {
        guard let context = modelContext else {
            logger.error("Failed to save message: ModelContext is nil")
            return
        }

        if conversation.modelContext == nil {
            logger.info("Inserting conversation into ModelContext")
            context.insert(conversation)
        }

        if message.modelContext == nil {
            logger.info(
                "Inserting new message into ModelContext: \(message.id)"
            )
            context.insert(message)
        }

        do {
            try context.save()
            logger.info("Successfully saved context to local storage")
        } catch {
            logger.error(
                "Failed to save ModelContext: \(error.localizedDescription, privacy: .public)"
            )
        }
    }
}
