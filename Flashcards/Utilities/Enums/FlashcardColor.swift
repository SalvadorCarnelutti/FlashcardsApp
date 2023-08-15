//
//  FlashcardColor.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI

enum FlashcardColor: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case clear
    case blue
    case cyan
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
    
    var color: Color {
        switch self {
        case .clear:
            return .clear
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .green:
            return .green
        case .indigo:
            return .indigo
        case .mint:
            return .mint
        case .orange:
            return .orange
        case .pink:
            return .pink
        case .purple:
            return .purple
        case .red:
            return .red
        case .teal:
            return .teal
        case .yellow:
            return .yellow
        }
    }
}
