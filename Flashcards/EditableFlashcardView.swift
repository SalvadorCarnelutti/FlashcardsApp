//
//  EditableFlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI

struct EditableFlashcardView: View {
    @ObservedObject var flashcardViewModel: FlashcardViewModel
    @FocusState var focusedField: FlashcardSide?
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(flashcardViewModel.side)
                        .font(.footnote)
                    Spacer()
                }
                HStack {
                    TextField(flashcardViewModel.placeholder,
                              text: $flashcardViewModel.text,
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
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}

#Preview {
    let flashcardViewModel = FlashcardViewModel(flashcardSide: .front)
    
    return EditableFlashcardView(flashcardViewModel: flashcardViewModel)
}
