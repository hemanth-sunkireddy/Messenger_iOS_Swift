//
//  Item.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 17/09/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
