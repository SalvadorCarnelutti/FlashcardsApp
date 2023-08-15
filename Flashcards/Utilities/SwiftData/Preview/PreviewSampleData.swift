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
        for card in SampleDeck.contents {
            container.mainContext.insert(object: card)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
