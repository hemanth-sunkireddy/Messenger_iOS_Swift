//
//  Message.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import Foundation

enum Sender {
    case user
    case assistant
}

enum Status {
    case sending
    case sent
    case failed
}

enum ConversationError: Error {
    case messageNotFound
}

struct Message: Identifiable, Equatable, Hashable {
    let id: UUID
    var text: String
    let sender: Sender
    let createdAt: Date
    var deliveryStatus: Status
}

struct Conversation: Hashable {
    let id: UUID
    var title: String
    var messages: [Message]
    var lastUpdated: Date

    mutating func addMessage(message: Message) {
        messages.append(message)
    }

    func getLatestMessage() -> Message? {
        return messages.last
    }

    func filter(by sender: Sender) -> [Message] {
        return messages.filter { message in
            return message.sender == sender
        }
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
        return messages.filter { message in
            return message.deliveryStatus == status
        }.count
    }

    func formatMessages(transform: (Message) -> String) -> [String] {
        var results: [String] = []
        for message in messages {
            results.append(transform(message))
        }
        return results
    }
}
