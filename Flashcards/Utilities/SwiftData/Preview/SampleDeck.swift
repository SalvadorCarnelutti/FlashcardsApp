//
//  SampleDeck.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftData

struct SampleDeck {
    static var contents: [Category] {
        let categories = [
            Category(name: "Math", color: "blue"),
            Category(name: "Science", color: "green"),
            Category(name: "Japanese", color: "purple"),
        ]
        
        for category in categories {
            let collection = Collection(name: "Scientist")
            let flashcard = Flashcard(prompt: "Who did X?", answer: "X was done by Y", collection: collection)
            collection.flashcards.append(flashcard)
            
            category.collections.append(collection)
        }
        
        return categories
    }
    
    static var collection: Collection {
        Collection(name: "Scientist")
    }
}
