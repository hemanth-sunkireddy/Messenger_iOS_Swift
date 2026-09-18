//
//  MessageBubbleView.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 18/09/26.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message

    var body: some View {
        VStack(alignment: message.sender == .user ? .trailing : .leading) {
            Text(message.text)
                .foregroundColor(
                    message.sender == .user ? .white : .black
                )
                .padding(8)
                .background(
                    message.sender == .user ? Color.blue : Color(.systemGray5)
                )
                .cornerRadius(12)
            
            Text(message.createdAt.formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .frame(
            maxWidth: .infinity,
            alignment: message.sender == .user ? .trailing : .leading
        )
    }
}
