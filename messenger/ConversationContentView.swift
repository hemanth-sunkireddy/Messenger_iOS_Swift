//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftUI
import SwiftData

struct ConversationContentView: View {
    var conversation: Conversation = Conversation(id: 1, title: "First Conversation", messages: [], lastUpdated: Date())
    
    init() {
        var messsage1 = Message(id: 1, text: "Hello!", sender: .user, createdAt: Date(), deliveryStatus: .sent)
        var message2 = Message(id: 2, text: "Hi! How can I help you", sender: .assistant, createdAt: Date(), deliveryStatus: .sending)
        var message3 = Message(id: 3, text: "I need some assistance with my account.", sender: .user, createdAt: Date(), deliveryStatus: .failed)
        conversation.addMessage(message: messsage1)
        conversation.addMessage(message: message2)
        conversation.addMessage(message: message3)
    }
    
    var body: some View {
        Text("\(conversation.title)")
        List(conversation.messages) { message in
            VStack {
                Text("\(message.text)")
            }
        }
    }

    private func start() {
        var messsage4 = Message(id: 4, text: "Good Morning!", sender: .user, createdAt: Date(), deliveryStatus: .sent)
        var message5 = Message(id: 5, text: "Good Morning! How should I assist you", sender: .assistant, createdAt: Date(), deliveryStatus: .sending)
        var message6 = Message(id: 6, text: "I need to know your products.", sender: .user, createdAt: Date(), deliveryStatus: .failed)

        var conversation1 = Conversation(id: 1, title: "First Conversation", messages: [], lastUpdated: Date())
        var conversation2 = Conversation(id: 2, title: "Second Conversation", messages: [], lastUpdated: Date())

        conversation2.addMessage(message: messsage4)
        conversation2.addMessage(message: message5)
        conversation2.addMessage(message: message6)

        let userMessages = conversation1.filter(by: .user)
        let sortedMessages = conversation1.sortedByDate()
        let latestMessage = conversation1.getLatestMessage()
        let failedCount = conversation1.count(by: .failed)

        print("User Messages: ", userMessages)
        print("\nSorted Messages: ", sortedMessages)

        if let latest = latestMessage {
            print("\nLatest Message: ", latest.text)
        } else {
            print("\nNo latest messages found.")
        }

        let previewList = conversation1.formatMessages { message in
            return "\(message.sender): \(message.text)"
        }
        print("\nFormatted Messges: ", previewList)

        do {
            let message = try conversation1.findMessage(by: 20)
            print("\n\(message.text)")
        } catch ConversationError.messageNotFound {
            print("\nError: Message not found")
        } catch {
            print("Unexpected error: \(error)")
        }

        var emptyConversation = Conversation(id: 3, title: "Empty Conversation", messages: [], lastUpdated: Date())
        let latestMessage2 = emptyConversation.getLatestMessage()
        if let latest = latestMessage2 {
            print("\nLatest Message: ", latest.text)
        } else {
            print("\nNo latest messages found.")
        }
    }
}

#Preview {
    ConversationContentView()
}
