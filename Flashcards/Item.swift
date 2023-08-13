//
//  Item.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
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
