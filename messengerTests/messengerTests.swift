//
//  messengerTests.swift
//  messengerTests
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import Testing

@testable import messenger

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

}
