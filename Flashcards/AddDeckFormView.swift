//
//  AddDeckFormViewModel.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI
import SwiftData
import Observation

@Observable final class AddDeckFormViewModel {
    var deckName: String = ""
    
    var getDeck: Deck {
        Deck(name: deckName.capitalized)
    }
    
    func getDeck(for category: Category) -> Deck {
        Deck(name: deckName.capitalized, category: category)
    }
}

struct AddDeckFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var decks: [Deck]
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var addDeckFormViewModel = AddDeckFormViewModel()
    private var addCategoryFormViewModel = AddCategoryFormViewModel()
    @FocusState private var deckNameFieldIsFocused: Bool
            
    @State var skipsCategory: Bool = false
    @State var selectedIndex: Int = 0
    @State var isNewCategoryFormPresented: Bool = false
    @State var isDeckAlertPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField(text: $addDeckFormViewModel.deckName) {
                        Text("Deck name")
                    }
                    .focused($deckNameFieldIsFocused)
                }
                
                Section("Category (Optional)") {
                    if categories.isNotEmpty {
                        Toggle("Skip", isOn: $skipsCategory)
                    }
                    AddDeckCategoryView(categories: categories,
                                        isNewCategoryFormPresented: $isNewCategoryFormPresented,
                                        addCategoryFormViewModel: AddCategoryFormViewModel(),
                                        selectedIndex: $selectedIndex)
                    .disabled(skipsCategory)
                }
                
                Button(action: addDeck) {
                    Text("Add deck")
                }
                .disabled(addDeckFormViewModel.deckName.isEmpty)
            }
            .onAppear {
                deckNameFieldIsFocused = true
            }
            .alert(isPresented: $isDeckAlertPresented) {
                Alert(title: Text("Deck name already exists"),
                      message: Text("Choose a different name"))
            }
        }
    }
    
    private func toggleNewCategory() {
        isNewCategoryFormPresented.toggle()
    }
    
    private func addDeck() {
        guard !decks.map({ $0.name }).contains(where: { $0.caseInsensitiveCompare(addDeckFormViewModel.deckName) == .orderedSame }) else {
            isDeckAlertPresented = true
            return
        }
        
        if skipsCategory || categories.isEmpty {
            modelContext.insert(addDeckFormViewModel.getDeck)
        } else {
            let category = categories[selectedIndex]
            modelContext.insert(category)
            modelContext.insert(addDeckFormViewModel.getDeck(for: category))
        }
        
        dismiss()
    }
}

#Preview {
    AddDeckFormView()
}

struct AddDeckCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    let categories: [Category]
    
    @Binding var isNewCategoryFormPresented: Bool
    let addCategoryFormViewModel: AddCategoryFormViewModel
    @Binding var selectedIndex: Int
    
    @State var isCategoryAlertPresented: Bool = false
    
    var body: some View {
        Group {
            if categories.isNotEmpty {
                ChooseCategoryPicker(selectedIndex: $selectedIndex,
                                     categories: categories)
            }
            Button(action: toggleNewCategory) {
                Text("Add new category")
            }
        }
        .sheet(isPresented: $isNewCategoryFormPresented) {
            AddCategoryFormView(isAlertPresented: $isCategoryAlertPresented,
                                isPresented: $isNewCategoryFormPresented,
                                addCategoryFormViewModel: addCategoryFormViewModel,
                                addCategory: addCategory)
            .presentationDetents([.medium])
            .padding()
        }
    }
    
    private func toggleNewCategory() {
        isNewCategoryFormPresented.toggle()
    }
    
    private func addCategory(category: Category) {
        guard !categories.map({ $0.name }).contains(category.name) else {
            isCategoryAlertPresented = true
            return
        }
        
        withAnimation {
            modelContext.insert(category)
        }
        
        // Insertion is not immediate, decks take a moment to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 , execute: {
            selectedIndex = categories.firstIndex(of: category) ?? 0
        })
        isNewCategoryFormPresented = false
    }
}
