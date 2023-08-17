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
            for collection in SampleDeck.collections {
                container.mainContext.insert(collection)
                
                let flashcard = Flashcard(prompt: "Who did X?", answer: "X was done by Y", collection: collection)
                container.mainContext.insert(flashcard)
                collection.flashcards.append(flashcard)
            }
            container.mainContext.insert(category)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
