//
//  DeckGalleryView.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI
import SwiftData
import Combine

struct DeckGalleryScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: Router
    
    @Query(sort: \Flashcard.creationDate) private var flashcards: [Flashcard]
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var editMode = EditMode.inactive
    @State var isNewCategoryFormPresented: Bool = false
    @State var isEditCategoryFormPresented: Bool = false
    @State private var wiggles = false
    
    private static let columns = [GridItem(.adaptive(minimum: 150))]
    let deck: Deck

    init(deck: Deck) {
        self.deck = deck
        // Workaround as of Xcode 15.6, SwiftData doesn't allow dynamic queries
        let deckName = deck.name
        
        let predicate = #Predicate<Flashcard> {
            $0.deck.name == deckName
        }
        
        _flashcards = Query(filter: predicate, sort: \Flashcard.creationDate, order: .reverse)
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
            
            LazyVGrid(columns: Self.columns, spacing: 20) {
                CardGalleryItemView(backgroundStyle: deck.flashcardBackgroundColor, action: addFlashcard) {
                    LabeledContent("Add Card") {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .labelsHidden()
                }
                .shadow(radius: 2)
                
                ForEach(flashcards) { flashcard in
                    CardGalleryItemView(backgroundStyle: deck.flashcardBackgroundColor.opacity(0.9)) {
                        selectFlashcard(flashcard)
                    } label: {
                        Text(flashcard.prompt)
                    }
                    .rotationEffect(.degrees(wiggles ? 2 : 0))
                    .animation(wiggles ? .easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default, value: wiggles)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $isEditCategoryFormPresented) {
            EditDeckCategoryView(categories: categories,
                                 deck: deck,
                                 isNewCategoryFormPresented: $isNewCategoryFormPresented,
                                 addCategoryFormViewModel: AddCategoryFormViewModel())
        }
        .environment(\.editMode, $editMode)
        .navigationTitle(deck.name)
        .onChange(of: editMode) {
            wiggles = editMode.isEditing
        }
    }
    
    private func addFlashcard() {
        let newFlashcard = Flashcard(prompt: "Sample Front",
                                     answer: "Sample Back",
                                     deck: deck)
        deck.addFlashcard(newFlashcard)
        modelContext.insert(newFlashcard)
        
        let flashcardCarouselViewModel = FlashcardsCarouselViewModel(flashcards: flashcards,
                                                                     selectedFlashcard: newFlashcard,
                                                                     isEditing: true)
        
        editMode = .inactive
        router.navigate(to: .flashcardsCarouselScreen(flashcardCarouselViewModel))
    }
    
    private func selectFlashcard(_ flashCard: Flashcard) {
        let flashcardCarouselViewModel = FlashcardsCarouselViewModel(flashcards: flashcards,
                                                                     selectedFlashcard: flashCard,
                                                                     isEditing: editMode.isEditing)
        
        editMode = .inactive
        router.navigate(to: .flashcardsCarouselScreen(flashcardCarouselViewModel))
    }
}

#Preview {
    MainActor.assumeIsolated {
        DeckGalleryScreen(deck: Deck(name: "Japanese"))
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
    @State private var selectedIndex: Int?
    
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
            State(initialValue: nil)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Group {
                        if categories.isNotEmpty {
                            OptionalChooseCategoryPicker(selectedIndex: $selectedIndex,
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
                        AddCategoryFormScreen(isAlertPresented: $isCategoryAlertPresented,
                                              addCategoryFormViewModel: addCategoryFormViewModel,
                                              addCategory: addCategory)
                        .presentationDetents([.medium])
                        .padding()
                    }
                    .onChange(of: selectedIndex) {
                        if let selectedIndex = selectedIndex {
                            deck.category = categories[selectedIndex]
                        } else {
                            deck.category = nil
                        }
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

struct OptionalChooseCategoryPicker: View {
    let selectedIndex: Binding<Int?>
    let categories: [Category]
    
    var body: some View {
        Picker("Select category", selection: selectedIndex) {
            Text("None").tag(Optional<Int>(nil))
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                HStack {
                    Text(category.name.capitalized)
                    // TODO: Maybe change in such a way I don't compare strings
                    if category.colorName != "clear" {
                        Image(systemName: "rectangle.fill")
                            .foregroundStyle(FlashcardColor(rawValue: category.colorName)!.color)
                    }
                }.tag(Optional(index))
            }
        }.id(categories)
            .pickerStyle(.navigationLink)
    }
}
