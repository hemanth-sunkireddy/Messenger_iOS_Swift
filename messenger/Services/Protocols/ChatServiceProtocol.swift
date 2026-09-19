//
//  ChatServiceProtocol.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation

protocol ChatServiceProtocol {
    func getInitialMessage() -> Message
    func getBotResponse() -> Message
}
