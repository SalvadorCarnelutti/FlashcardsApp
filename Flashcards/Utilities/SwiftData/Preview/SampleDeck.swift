//
//  SampleDeck.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftData

struct SampleDeck {
    static var categories: [Category] = [
        Category(name: "Math", color: "blue"),
        Category(name: "Science", color: "green"),
        Category(name: "Japanese", color: "purple"),
    ]
    
    static var decks: [Deck] = [
        Deck(name: "Beginner"),
        Deck(name: "Intermediate"),
        Deck(name: "Advanced")
    ]
    
    static var deck: Deck { Deck(name: "Japanese") }
    static var flashcard: Flashcard { Flashcard(prompt: "Nodo", answer: "Throat", deck: Self.deck) }
}
