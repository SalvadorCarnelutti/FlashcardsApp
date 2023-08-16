//
//  AddFlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import Observation

final class AddFlashcardViewModel: ObservableObject {
    @Published var flashcardPromptViewModel = FlashcardViewModel(text: "Sample Front",
                                                                 side: "FRONT",
                                                                 color: .cyan)
    
    @Published var flashcardAnswerViewModel = FlashcardViewModel(text: "Sample Back",
                                                                 side: "BACK",
                                                                 color: .yellow)
    
    var getFlashcard: Flashcard {
        Flashcard(prompt: flashcardPromptViewModel.text,
                  answer: flashcardAnswerViewModel.text,
                  collection: Collection(name: "Random"))
    }
}

struct AddFlashcardView: View {
    @StateObject var addFlashcardViewModel = AddFlashcardViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            EditableFlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardPromptViewModel)
            EditableFlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardAnswerViewModel)
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
    AddFlashcardView()
        .modelContainer(for: Category.self, inMemory: true)
}

#Preview("Back") {
    AddFlashcardView()
        .modelContainer(for: Category.self, inMemory: true)
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

