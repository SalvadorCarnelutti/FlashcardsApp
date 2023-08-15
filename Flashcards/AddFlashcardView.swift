//
//  AddFlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import Observation

@Observable final class AddFlashcardViewModel {
    let flashcardPromptViewModel = FlashcardViewModel(text: "Sample Front",
                                                      side: "FRONT",
                                                      color: .cyan)
    
    let flashcardAnswerViewModel = FlashcardViewModel(text: "Sample Back",
                                                      side: "BACK",
                                                      color: .yellow)
    
    var getFlashcard: Flashcard {
        Flashcard(prompt: flashcardPromptViewModel.text, answer: flashcardAnswerViewModel.text)
    }
}

struct AddFlashcardView: View {
    var addFlashcardViewModel: AddFlashcardViewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            FlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardPromptViewModel)
            FlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardAnswerViewModel)
            Spacer()
            Button(action: addCard) {
                Text("Add flashcard")
                    .padding()
                    .background(.blue)
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
            }
        }
        .padding()
    }
    
    func addCard() {
        let model = addFlashcardViewModel.getFlashcard
        
        modelContext.insert(model)
    }
}

#Preview("Front") {
    AddFlashcardView(addFlashcardViewModel: AddFlashcardViewModel())
}

#Preview("Back") {
    AddFlashcardView(addFlashcardViewModel: AddFlashcardViewModel())
}

final class FlashcardViewModel: ObservableObject {
    var text: String
    let side: String
    let color: Color
    
    init(text: String, side: String, color: Color) {
        self.text = text
        self.side = side
        self.color = color
    }
}
