//
//  AddFlashcardView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import Observation

final class AddFlashcardViewModel: ObservableObject {
    @Published var flashcardPromptViewModel = FlashcardViewModel(flashcardSide: .front)
    
    @Published var flashcardAnswerViewModel = FlashcardViewModel(flashcardSide: .back)
    
    private var promptText: String { flashcardPromptViewModel.text }
    private var answerText: String { flashcardAnswerViewModel.text }
    
    var isPromptEmpty: Bool { promptText.isEmpty }
    var isAnswerEmpty: Bool { answerText.isEmpty }
    
    var getFlashcard: Flashcard {
        Flashcard(prompt: promptText,
                  answer: answerText,
                  collection: Collection(name: "Random"))
    }
}

struct AddFlashcardView: View {
    @StateObject var addFlashcardViewModel = AddFlashcardViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var focusedField: FlashcardSide?
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            /*
             focusedField refers to the value inside the property wrapper.
             _focusedField refers to the property wrapper.
             $focusedField refers to the property wrapper's projected value; in the case of @FocusState, that is a Binding.
             */
            EditableFlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardPromptViewModel, focusedField: _focusedField)
            EditableFlashcardView(flashcardViewModel: addFlashcardViewModel.flashcardAnswerViewModel, focusedField: _focusedField)
            
            /*
             More explanation:
             
             Given one variable declaration, @Binding var momentDate: Date, you can access three variables:

             self._momentDate is the Binding<Date> struct itself.
             self.momentDate, equivalent to self._momentDate.wrappedValue, is a Date. You would use this when rendering the date in the view's body.
             self.$momentDate, equivalent to self._momentDate.projectedValue, is also the Binding<Date>. You would pass this down to child views if they need to be able to change the date.
             */
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
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Both sides must be filled"),
                  message: Text("Fill missing contents"))
        }

        .onAppear {
            focusedField = .front
        }
    }
    
    func addCard() {
        switch (addFlashcardViewModel.isPromptEmpty, addFlashcardViewModel.isAnswerEmpty) {
        case (true, _):
            focusedField = .front
            isAlertPresented = true
        case (_, true):
            focusedField = .back
            isAlertPresented = true
        case (false, false):
            let model = addFlashcardViewModel.getFlashcard
            
            modelContext.insert(model)
        }
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
    var flashcardSide: FlashcardSide
    var text: String = ""
    let placeholder: String
    let side: String
    let color: Color
    
    init(flashcardSide: FlashcardSide) {
        self.flashcardSide = flashcardSide
        self.placeholder = flashcardSide.placeholder
        self.side = flashcardSide.side
        self.color = flashcardSide.color
    }
}

