//
//  FlashcardCarousel.swift
//  Flashcards
//
//  Created by Salvador on 8/25/23.
//

import SwiftUI
import SwiftData

struct FlashcardCarouselViewModel: Hashable {
    let flashcards: [Flashcard]
    let selectedFlashcard: Flashcard
    
    init(flashcards: [Flashcard], selectedFlashcard: Flashcard) {
        self.flashcards = flashcards
        self.selectedFlashcard = selectedFlashcard
    }
}

struct FlashcardCarousel: View {
    @State private var selectedFlashcardID: Flashcard.ID?
    
    let flashcards: [Flashcard]
    let initialFlashcardID: Flashcard.ID
    
    init(flashcardCarouselViewModel: FlashcardCarouselViewModel) {
        flashcards = flashcardCarouselViewModel.flashcards
        initialFlashcardID = flashcardCarouselViewModel.selectedFlashcard.id
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(flashcards) { flashcard in
                    FlashcardView(flashcard: flashcard)
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $selectedFlashcardID)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .onAppear { selectedFlashcardID = initialFlashcardID }
    }
}

//#Preview {
//    var flashcards = [Flashcard]()
//    
//    for deck in SampleDeck.decks {
//        let flashcard = Flashcard(prompt: "Who did X?", answer: "X was done by Y", deck: deck)
//        flashcards.append(flashcard)
//    }
//    
//    return FlashcardCarousel(flashcards: flashcards)
//        .modelContainer(previewContainer)
//}
