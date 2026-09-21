//
//  ChatService.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation
import OSLog

struct OllamaChatRequest: Encodable {
    let model: String
    let messages: [OllamaMessage]
    let stream: Bool
}

struct OllamaMessage: Codable {
    let role: String
    let content: String
}

struct OllamaChatResponse: Decodable {
    let message: OllamaMessage
}

class OllamaChatService: ChatServiceProtocol {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "messenger",
        category: "OllamaChatService"
    )
    private let url = URL(string: "http://localhost:11434/api/chat")!
    private let model: String

    init(model: String = "gemma4") {
        self.model = model
    }

    func getInitialMessage() -> Message {
        Message(
            id: UUID(),
            text: "Hello! How can I help you?",
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
    }

    func getBotResponse(history: [Message]) async throws -> Message {
        let messages = history.map {
            OllamaMessage(
                role: $0.sender == .assistant ? "assistant" : "user",
                content: $0.text
            )
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(
                OllamaChatRequest(model: model, messages: messages, stream: false)
            )
        } catch {
            logger.error(
                "Failed to encode request body: \(error.localizedDescription)"
            )
            throw error
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            logger.error(
                "Network request failed: \(error.localizedDescription)"
            )
            throw error
        }

        if let httpResponse = response as? HTTPURLResponse {
            logger.info(
                "Ollama API Response Status Code: \(httpResponse.statusCode)"
            )
        }

        let result: OllamaChatResponse
        do {
            result = try JSONDecoder().decode(
                OllamaChatResponse.self,
                from: data
            )
        } catch {
            logger.error(
                "Failed to decode Ollama response: \(error.localizedDescription)"
            )
            throw error
        }

        logger.info("Ollama Response Message: \(result.message.content)")

        return Message(
            id: UUID(),
            text: result.message.content,
            sender: .assistant,
            createdAt: Date(),
            deliveryStatus: .sent
        )
    }
}
