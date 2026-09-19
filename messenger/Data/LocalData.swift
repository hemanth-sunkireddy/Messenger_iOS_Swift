//
//  LocalData.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation

var conversationData = Conversation(
    id: 1,
    title: "Assistant Bot",
    messages: [],
    lastUpdated: Date()
)

let messsage1 = Message(
    id: 1,
    text: "Hello! How can I help you",
    sender: .assistant,
    createdAt: Date(),
    deliveryStatus: .sent
)
