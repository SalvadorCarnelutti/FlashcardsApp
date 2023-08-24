//
//  FlashcardsGalleryView.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI
import SwiftData

struct FlashcardsGalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var flashcards: [Flashcard]
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @Bindable var deck: Deck
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State var isNewCategoryFormPresented: Bool = false
    
    let selectFlashcard: (Flashcard) -> Void
    let addFlashcard: () -> Void
    
    @State var isEditCategoryFormPresented: Bool = false
    
    init(deck: Deck, selectFlashcard: @escaping (Flashcard) -> Void, addFlashcard: @escaping () -> Void) {
        self.deck = deck
        self.selectFlashcard = selectFlashcard
        self.addFlashcard = addFlashcard
        
        // Workaround as of Xcode 15.6, SwiftData doesn't allow dynamic queries
        let deckName = deck.name
        
        let predicate = #Predicate<Flashcard> {
            $0.deck.name == deckName
        }
        
        _flashcards = Query(filter: predicate, sort: \Flashcard.prompt)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.clear)
                    LabeledContent("Category") {
                        Text(deck.category?.name ?? "None")
                    }
                }
                .padding()
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 3)
                .overlay(alignment: .top) {
                    Rectangle().frame(maxWidth: .infinity, maxHeight: 7, alignment: .top)
                        .foregroundColor(deck.flashcardBackgroundColor)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 7, topTrailingRadius: 7))
                }
                .onTapGesture {
                    isEditCategoryFormPresented = true
                }
            }
            .padding()
            
            LazyVGrid(columns: columns, spacing: 20) {
                // TODO: Card might not have a category remove force unwrapping
                CardGalleryItem(backgroundStyle: deck.flashcardBackgroundColor, action: addFlashcard) {
                    LabeledContent("Add Card") {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .labelsHidden()
                }
                .shadow(radius: 2)
                
                ForEach(flashcards) { flashcard in
                    CardGalleryItem(backgroundStyle: deck.flashcardBackgroundColor) {
                        selectFlashcard(flashcard)
                    } label: {
                        Text(flashcard.prompt)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditCategoryFormPresented) {
            EditDeckCategoryView(categories: categories,
                                 deck: deck,
                                 isNewCategoryFormPresented: $isNewCategoryFormPresented,
                                 addCategoryFormViewModel: AddCategoryFormViewModel())
        }
        .navigationTitle(deck.name)
    }
}

#Preview {
    MainActor.assumeIsolated {
        FlashcardsGalleryView(deck: Deck(name: "Japanese"),
                              selectFlashcard: { _ in },
                              addFlashcard: {})
        .modelContainer(previewContainer)
    }
}

struct EditDeckCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let categories: [Category]
    let deck: Deck
    
    @Binding var isNewCategoryFormPresented: Bool
    let addCategoryFormViewModel: AddCategoryFormViewModel
    @State var selectedIndex: Int
    
    @State var isCategoryAlertPresented: Bool = false
    
    init(categories: [Category],
         deck: Deck,
         isNewCategoryFormPresented: Binding<Bool>,
         addCategoryFormViewModel: AddCategoryFormViewModel) {
        self.categories = categories
        self.deck = deck
        self._isNewCategoryFormPresented = isNewCategoryFormPresented
        self.addCategoryFormViewModel = addCategoryFormViewModel
        self._selectedIndex = if let category = deck.category {
            State(initialValue: categories.firstIndex(of: category) ?? 0)
        } else {
            State(initialValue: 0)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Group {
                        if categories.isNotEmpty {
                            ChooseCategoryPicker(selectedIndex: $selectedIndex,
                                                 categories: categories)
                        }
                        Button(action: toggleNewCategoryFormPresented) {
                            Text("Add new category")
                        }
                        if deck.category != nil {
                            Button(action: clearCategory) {
                                Text("Clear category")
                            }
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
                    // TODO: At the moment only a category gets selected when tapping a different index, haven't found a stable to detect when the user taps the same index or just when navigation to the picker selection view
                    .onChange(of: selectedIndex) {
                        deck.category = categories[selectedIndex]
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleNewCategoryFormPresented() {
        isNewCategoryFormPresented.toggle()
    }
    
    private func clearCategory() {
        deck.category = nil
        dismiss()
    }
    
    private func addCategory(category: Category) {
        guard !categories.map({ $0.name }).contains(category.name) else {
            isCategoryAlertPresented = true
            return
        }
        
        modelContext.insert(category)
        deck.category = category
        isNewCategoryFormPresented = false
        
        dismiss()
    }
}
