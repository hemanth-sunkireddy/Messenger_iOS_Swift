//
//  messengerTests.swift
//  messengerTests
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import Foundation
import Testing

@testable import messenger

struct MockChatService: ChatServiceProtocol {
    var initialMessageToReturn: Message = Message(
        id: UUID(),
        text: "Mock Initial Message",
        sender: .assistant,
        createdAt: Date(),
        deliveryStatus: .sent
    )

    var botResponseToReturn: Message = Message(
        id: UUID(),
        text: "Mock Bot Response",
        sender: .assistant,
        createdAt: Date(),
        deliveryStatus: .sent
    )

    func getInitialMessage() -> Message {
        return initialMessageToReturn
    }

    func getBotResponse() -> Message {
        return botResponseToReturn
    }
}

struct messengerTests {

    @Test("Initialization adds initial bot message")
    func testInitialization() {
        let viewModel = ConversationViewModel()

        #expect(
            viewModel.conversation.messages.contains(where: {
                $0.text == "Hello! How can I help you"
                    && $0.sender == .assistant
            })
        )
    }

    @Test("Sending a valid message adds both user message and bot response")
    func testSendMessageSuccess() {
        let viewModel = ConversationViewModel()
        let initialCount = viewModel.conversation.messages.count

        viewModel.sendMessage(messageInput: "How are you?")

        #expect(viewModel.conversation.messages.count == initialCount + 2)

        let lastTwoMessages = viewModel.conversation.messages.suffix(2)
        #expect(lastTwoMessages.first?.text == "How are you?")
        #expect(lastTwoMessages.first?.sender == .user)
        #expect(lastTwoMessages.last?.sender == .assistant)
    }

    @Test("Sending an empty message does nothing")
    func testSendMessageEmptyInput() {
        let viewModel = ConversationViewModel()
        let initialCount = viewModel.conversation.messages.count

        viewModel.sendMessage(messageInput: "")

        #expect(viewModel.conversation.messages.count == initialCount)
    }

    @Test("Sending multiple messages appends mock responses")
    func testSendMultipleMessagesWithMock() {
        let viewModel = ConversationViewModel(chatService: MockChatService())

        viewModel.sendMessage(messageInput: "First Message")
        viewModel.sendMessage(messageInput: "Second Message")

        #expect(
            viewModel.conversation.messages.filter { $0.sender == .user }.count
                == 2
        )
    }
}
