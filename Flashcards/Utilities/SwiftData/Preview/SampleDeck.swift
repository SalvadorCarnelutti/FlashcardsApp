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
    
    static var collections: [Collection] = [
        Collection(name: "Beginner"),
        Collection(name: "Intermediate"),
        Collection(name: "Advanced")
    ]
}
