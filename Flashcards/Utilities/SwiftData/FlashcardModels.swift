//
//  FlashcardModels.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftData
import SwiftUI

// SwiftData enhances the model by automatically conferring it the PersistentModel conformance. This means that your model is now Identifiable, Observable, and Hashable.
@Model
final class Category {
    @Attribute(.unique) var name: String
    var decks: [Deck]
    let colorName: String
    
    init(name: String, decks: [Deck] = [], color: String) {
        self.name = name
        self.decks = decks
        self.colorName = color
    }
    
    @Transient var isClearColored: Bool { colorName == "clear" }
}

@Model
final class Deck {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var flashcards: [Flashcard]
    var category: Category?
    
    init(name: String, flashcards: [Flashcard] = [], category: Category? = nil) {
        self.name = name
        self.flashcards = flashcards
        self.category = category
    }
    
    @Transient var color: Color {
        guard let category = category else { return .clear }
        
        return FlashcardColor(rawValue: category.colorName)?.color ?? .clear
    }
    
    @Transient var flashcardBackgroundColor: Color {
        guard let category = category, !category.isClearColored else { return .flashcardsTheme }
        
        return FlashcardColor(rawValue: category.colorName)?.color ?? .flashcardsTheme
    }
    
    func addFlashcard(_ flashcard: Flashcard) { flashcards.append(flashcard) }
}

@Model
final class Flashcard {
    var prompt: String
    var answer: String
    var deck: Deck
    var creationDate: Date
    
    init(prompt: String, answer: String, deck: Deck, creationDate: Date = .now) {
        self.prompt = prompt
        self.answer = answer
        self.deck = deck
        self.creationDate = creationDate
    }
    
    @Transient var backgroundColor: Color {
        deck.flashcardBackgroundColor
    }
}
