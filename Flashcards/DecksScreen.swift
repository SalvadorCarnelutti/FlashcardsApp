//
//  DecksScreen.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftUI
import SwiftData

struct DecksScreen: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Category> { $0.decks.count > 0 }, sort: \Category.name) private var categories: [Category]
    @Query(filter: #Predicate<Deck> { $0.category == nil }) private var decks: [Deck]
    
    @State var isFormPresented: Bool = false
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            List {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.decks) { deck in
                            NavigationLink(value: Router.Route.deckGalleryScreen(deck)) {
                                Text(deck.name.capitalized)
                            }
                        }
                        .onDelete { indexSet in
                            deleteCategoryDecks(category: category, offsets: indexSet)
                        }
                    } header: {
                        HStack {
                            Text(category.name.capitalized)
                            Image(systemName: "rectangle.fill")
                                .foregroundStyle(FlashcardColor(rawValue: category.colorName)!.color)
                        }
                    }
                }
                
                Section {
                    ForEach(decks) { deck in
                        NavigationLink(deck.name, value: Router.Route.deckGalleryScreen(deck))
                    }
                    .onDelete(perform: deleteDecks)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: toggleForm) {
                        Label("Add category", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Decks")
            .overlay {
                if categories.isEmpty && decks.isEmpty {
                    ContentUnavailableView {
                        Label("No flashcards at the moment", systemImage: "rectangle.slash")
                    } description: {
                        Text("Start adding on the top-right")
                    }
                }
            }
            .navigationDestination(for: Router.Route.self) { route in
                switch route {
                case let .deckGalleryScreen(deck):
                    DeckGalleryScreen(deck: deck)
                case let .flashcardsCarouselScreen(flashcardsCarouselViewModel):
                    FlashcardsCarouselScreen(flashcardsCarouselViewModel: flashcardsCarouselViewModel)
                }
            }
            .sheet(isPresented: $isFormPresented) {
                AddDeckFormScreen()
            }
        }
    }
    
    private func deleteCategoryDecks(category: Category, offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(category.decks[index])
            }
        }
    }
    
    private func deleteDecks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(decks[index])
            }
        }
    }
    
    private func toggleForm() {
        isFormPresented.toggle()
    }
}

#Preview("Empty") {
    DecksScreen()
        .modelContainer(for: Category.self, inMemory: true)
}

#Preview("Non empty") {
    MainActor.assumeIsolated {
        DecksScreen()
            .modelContainer(previewContainer)
    }
}
