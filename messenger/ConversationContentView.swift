//
//  ContentView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import SwiftData
import SwiftUI

struct ConversationContentView: View {
    @State private var messageInput: String = ""

    @State var conversation: Conversation

    init() {
        
        var initial = Conversation(
                id: 1,
                title: "First Conversation",
                messages: [],
                lastUpdated: Date()
            )
            
            let messsage1 = Message(id: 1, text: "Hello!", sender: .user, createdAt: Date(), deliveryStatus: .sent)
            let message2 = Message(id: 2, text: "Hi! How can I help you", sender: .assistant, createdAt: Date(), deliveryStatus: .sending)
            let message3 = Message(id: 3, text: "I need some assistance with my account.", sender: .user, createdAt: Date(), deliveryStatus: .failed)
            
            initial.addMessage(message: messsage1)
            initial.addMessage(message: message2)
            initial.addMessage(message: message3)
            
            _conversation = State(initialValue: initial)
    }

    var body: some View {
        VStack {
            Text("\(conversation.title)")
            List(conversation.messages) { message in
                VStack {
                    Text("\(message.text)")
                        .frame(
                            maxWidth: .infinity,
                            alignment: message.sender == .user
                            ? .trailing : .leading
                        )
                }
                .listRowSeparator(.hidden)
            }
            HStack {
                TextField("Enter your Message..", text: $messageInput)
                Image(systemName: "paperplane.fill")
            }
            .padding(10)
        }

    }
}

#Preview {
    ConversationContentView()
}
