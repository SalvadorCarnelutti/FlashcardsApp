//
//  FlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI

struct FlashcardView: View {
    let flashcardViewModel: FlashcardViewModel
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(flashcardViewModel.side)
                        .font(.footnote)
                        .padding(5)
                        .background(flashcardViewModel.color.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                }
                HStack {
                    Text(flashcardViewModel.text)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
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
    
    return FlashcardView(flashcardViewModel: flashcardViewModel)
}
