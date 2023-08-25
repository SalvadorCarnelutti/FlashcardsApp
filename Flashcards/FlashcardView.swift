//
//  FlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    
    var body: some View {
        CardContainerView {
            VStack {
                HStack {
                    Text("FRONT")
                        .font(.footnote)
                        .padding(5)
                        .background(flashcard.backgroundColor.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                }
                HStack {
                    Text(flashcard.prompt)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(flashcard.backgroundColor.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical, 40)
            }
            .padding()
            .background(flashcard.backgroundColor.opacity(0.7))
        }
        .padding()
    }
}

//#Preview {
//    FlashcardView(flashcard: Flashcard(prompt: "Who was x", answer: "It was Y", deck: Deck(name: "Doers")))
//        .modelContainer(previewContainer)
//}
