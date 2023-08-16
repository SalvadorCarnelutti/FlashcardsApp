//
//  FlashcardSide.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI

enum FlashcardSide {
    case front
    case back
    
    var placeholder: String {
        switch self {
        case .front:
            return "Sample Front"
        case .back:
            return "Sample Back"
        }
    }
    
    var side: String {
        switch self {
        case .front:
            return "FRONT"
        case .back:
            return "BACK"
        }
    }
    
    var color: Color {
        switch self {
        case .front:
            return .cyan
        case .back:
            return .yellow
        }
    }
}
