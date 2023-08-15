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
        
        for category in SampleDeck.contents {
            let collection = Collection(name: "Scientist")
            container.mainContext.insert(collection)
            
            let flashcard = Flashcard(prompt: "Who did X?", answer: "X was done by Y", collection: collection)
            collection.flashcards.append(flashcard)
            
            category.collections = [collection]
            
            container.mainContext.insert(category)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
