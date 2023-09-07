//
//  FlashcardEditorView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import Observation

struct FlashcardEditorView: View {
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var focusedField: FlashcardSide?
    
    let flashcard: Flashcard
    
    var body: some View {
        VStack {
            /*
             focusedField refers to the value inside the property wrapper.
             _focusedField refers to the property wrapper.
             $focusedField refers to the property wrapper's projected value; in the case of @FocusState, that is a Binding.
             */
            EditableFlashcardView(flashcardViewModel: EditableFlashcardViewModel(flashcardSide: .front, flashcard: flashcard),
                                  focusedField: _focusedField)
            EditableFlashcardView(flashcardViewModel: EditableFlashcardViewModel(flashcardSide: .back, flashcard: flashcard),
                                  focusedField: _focusedField)
            
            /*
             More explanation:
             
             Given one variable declaration, @Binding var momentDate: Date, you can access three variables:

             self._momentDate is the Binding<Date> struct itself.
             self.momentDate, equivalent to self._momentDate.wrappedValue, is a Date. You would use this when rendering the date in the view's body.
             self.$momentDate, equivalent to self._momentDate.projectedValue, is also the Binding<Date>. You would pass this down to child views if they need to be able to change the date.
             */
        }
        .padding()
        
        .onAppear {
            focusedField = .front
        }
    }
}

#Preview("Front") {
    FlashcardEditorView(flashcard: SampleDeck.flashcard)
        .modelContainer(for: Category.self, inMemory: true)
}

#Preview("Back") {
    FlashcardEditorView(flashcard: SampleDeck.flashcard)
        .modelContainer(for: Category.self, inMemory: true)
}

