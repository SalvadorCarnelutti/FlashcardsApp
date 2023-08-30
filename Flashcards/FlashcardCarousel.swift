//
//  FlashcardCarousel.swift
//  Flashcards
//
//  Created by Salvador on 8/25/23.
//

import SwiftUI
import SwiftData

// TODO: When removing a card update flashacards shown
struct FlashcardCarouselViewModel: Hashable {
    var flashcards: [Flashcard]
    let selectedFlashcard: Flashcard
    let isEditing: Bool
    
    var initialFlashcardID: Flashcard.ID { selectedFlashcard.id }
    
    init(flashcards: [Flashcard], selectedFlashcard: Flashcard, isEditing: Bool) {
        self.flashcards = flashcards
        self.selectedFlashcard = selectedFlashcard
        self.isEditing = isEditing
    }
}

struct FlashcardCarousel: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFlashcardID: Flashcard.ID?
    @State var flashcards: [Flashcard]
    var viewModel: FlashcardCarouselViewModel
    
    init(flashcardCarouselViewModel: FlashcardCarouselViewModel) {
        viewModel = flashcardCarouselViewModel
        self._flashcards = State(initialValue: flashcardCarouselViewModel.flashcards)
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(flashcards) { flashcard in
                        Group {
                            if viewModel.isEditing {
                                FlashcardEditorView(flashcard: flashcard)
                            } else {
                                FlashcardView(flashcard: flashcard)
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            if viewModel.isEditing {
                Spacer()
                Button(action: deleteFlashcard) {
                    Text("Delete")
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .scrollPosition(id: $selectedFlashcardID)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .onAppear { selectedFlashcardID = viewModel.initialFlashcardID }
        .navigationTitle(viewModel.isEditing ? "Edit Mode" : "Read mode")
    }

    
    private func deleteFlashcard() {
        if let selectedIndex = flashcards.firstIndex(where: { $0.id == selectedFlashcardID }) {
            withAnimation {
                modelContext.delete(flashcards[selectedIndex])
                flashcards.remove(at: selectedIndex)
                
                guard flashcards.isNotEmpty else {
                    dismiss()
                    return
                }
                
                let newSelectedIndex = selectedIndex < flashcards.count ? selectedIndex : selectedIndex.advanced(by: -1)
                selectedFlashcardID = flashcards[newSelectedIndex].id

            }   
        }
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
