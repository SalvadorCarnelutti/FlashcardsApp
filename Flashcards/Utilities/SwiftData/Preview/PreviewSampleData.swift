//
//  PreviewSampleData.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Category.self, ModelConfiguration(inMemory: true)
        )
        
        for category in SampleDeck.categories {
            for deck in SampleDeck.decks {
                container.mainContext.insert(deck)
                
                let flashcard = Flashcard(prompt: "Who did X?", answer: "X was done by Y", deck: deck)
                container.mainContext.insert(flashcard)
                deck.flashcards.append(flashcard)
            }
            container.mainContext.insert(category)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
