//
//  FlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI

struct FlashcardView: View {
    @State private var flipped = false
    
    var front: Angle { flipped ? .degrees(180) : .degrees(0) }
    var back: Angle { flipped ? .degrees(0) : .degrees(-180) }
    
    let flashcard: Flashcard
    
    var body: some View {
        ZStack {
            ReadCard(side: "FRONT", text: flashcard.prompt, backgroundColor: flashcard.backgroundColor)
                .horizontalFlip(front, visible: !flipped)
            
            ReadCard(side: "BACK", text: flashcard.answer, backgroundColor: flashcard.backgroundColor)
                .horizontalFlip(back, visible: flipped)
        }
        .onTapGesture {
            withAnimation { flipped.toggle() }
        }
    }
}

//#Preview {
//    FlashcardView(flashcard: Flashcard(prompt: "Who was x", answer: "It was Y", deck: Deck(name: "Doers")))
//        .modelContainer(previewContainer)
//}

struct ReadCard: View {
    let side: String
    let text: String
    let backgroundColor: Color
    
    var body: some View {
        CardContainerView {
            VStack {
                HStack {
                    Text(side)
                        .font(.footnote)
                        .padding(5)
                        .background(backgroundColor.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                }
                HStack {
                    Text(text)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(backgroundColor.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical, 40)
            }
            .padding()
            .background(backgroundColor.opacity(0.7))
        }
        .padding()

    }
}
