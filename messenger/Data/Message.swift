//
//  Message.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import Foundation
import SwiftData

enum Sender: String, Codable {
    case user
    case assistant
}

enum Status: String, Codable {
    case sending
    case sent
    case failed
}

enum ConversationError: Error {
    case messageNotFound
}

@Model
final class Message: Identifiable, Equatable {
    @Attribute(.unique) var id: UUID
    var text: String
    var sender: Sender
    var createdAt: Date
    var deliveryStatus: Status

    init(
        id: UUID = UUID(),
        text: String,
        sender: Sender,
        createdAt: Date = Date(),
        deliveryStatus: Status = .sent
    ) {
        self.id = id
        self.text = text
        self.sender = sender
        self.createdAt = createdAt
        self.deliveryStatus = deliveryStatus
    }
}

@Model
final class Conversation: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var messages: [Message]
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        title: String = "New Chat",
        messages: [Message] = [],
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.messages = messages
        self.lastUpdated = lastUpdated
    }

    func addMessage(message: Message) {
        messages.append(message)
    }

    func getLatestMessage() -> Message? {
        return messages.last
    }

    func filter(by sender: Sender) -> [Message] {
        return messages.filter { $0.sender == sender }
    }

    func messageCount() -> Int {
        return messages.count
    }

    func sortedByDate() -> [Message] {
        return messages.sorted { firstMessage, secondMessage in
            return firstMessage.createdAt < secondMessage.createdAt
        }
    }

    func findMessage(by id: UUID) throws -> Message {
        guard
            let message = messages.first(where: { message in message.id == id })
        else {
            throw ConversationError.messageNotFound
        }
        return message
    }

    func count(by status: Status) -> Int {
        return messages.filter { $0.deliveryStatus == status }.count
    }

    func formatMessages(transform: (Message) -> String) -> [String] {
        var results: [String] = []
        for message in messages {
            results.append(transform(message))
        }
        return results
    }
}
