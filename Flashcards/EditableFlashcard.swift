//
//  EditableFlashcard.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI

final class EditableFlashcardViewModel: ObservableObject {
    @Bindable var flashcard: Flashcard
    let flashcardSide: FlashcardSide
    
    var sideText: String { flashcardSide.side }
    var color: Color { flashcardSide.color }
    var placeholder: String { flashcardSide.placeholder }
    var textBind: Binding<String> { flashcardSide == .front ? $flashcard.prompt : $flashcard.answer }
    
    init(flashcardSide: FlashcardSide, flashcard: Flashcard) {
        self.flashcard = flashcard
        self.flashcardSide = flashcardSide
    }
}

struct EditableFlashcard: View {
    @ObservedObject var flashcardViewModel: EditableFlashcardViewModel
    @FocusState var focusedField: FlashcardSide?
    
    var body: some View {
        CardContainerView {
            VStack {
                HStack {
                    Text(flashcardViewModel.sideText)
                        .font(.footnote)
                    Spacer()
                }
                HStack {
                    TextField(flashcardViewModel.placeholder,
                              text: flashcardViewModel.textBind,
                              axis: .vertical)
                    .focused($focusedField, equals: flashcardViewModel.flashcardSide)
                    .multilineTextAlignment(.center)
                    .lineLimit(3, reservesSpace: true)
                    .font(.title3)
                    .background(flashcardViewModel.color.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical, 40)
            }
            .padding()
            .background(flashcardViewModel.color.opacity(0.7))
        }
        .padding()
    }
}

#Preview {
    let flashcardViewModel = EditableFlashcardViewModel(flashcardSide: .front, flashcard: SampleDeck.flashcard)
    
    return EditableFlashcard(flashcardViewModel: flashcardViewModel)
}
