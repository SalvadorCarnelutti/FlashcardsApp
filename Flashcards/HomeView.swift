//
//  HomeView.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftUI
import SwiftData

enum Route: Hashable {
    case flashcardsGalleryView(Deck)
    case category(Category)
    case deck(Deck)
    case flashcard(Flashcard)
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Category> { $0.decks.count > 0 }, sort: \Category.name) private var categories: [Category]
    @Query(filter: #Predicate<Deck> { $0.category == nil }) private var decks: [Deck]
    @State var isFormPresented: Bool = false
    
    @State private var navigationPath: [Route] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.decks) { deck in
                            NavigationLink(value: Route.flashcardsGalleryView(deck)) {
                                Text(deck.name.capitalized)
                            }
                        }
                        .onDelete { indexSet in
                            deleteCategoryDecks(category: category, offsets: indexSet)
                        }
                    } header: {
                        HStack{
                            Text(category.name.capitalized)
                            Image(systemName: "rectangle.fill")
                                .foregroundStyle(FlashcardColor(rawValue: category.colorName)!.color)
                        }
                    }
                }
                
                Section {
                    ForEach(decks) { deck in
                        NavigationLink(deck.name, value: Route.flashcardsGalleryView(deck))
                    }
                    .onDelete(perform: deleteDecks)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
//                    NavigationLink(destination: AddFlashcardView()) {
//                        Label("Add category", systemImage: "plus")
//                    }
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
            .sheet(isPresented: $isFormPresented) {
                AddDeckFormView()
//                AddCategoryFormView(addCategoryFormViewModel: AddCategoryFormViewModel(), addAction: { _ in })
//                    .presentationDetents([.medium])
//                    .padding()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .flashcardsGalleryView(deck):
                    DeckGalleryView(deck: deck,
                                    selectFlashcard: selectFlashcard) {
                        withAnimation {
                            let newFlashcard = Flashcard(prompt: "Sample Front",
                                                         answer: "Sample Back",
                                                         deck: deck)
                            deck.addFlashcard(newFlashcard)
                            modelContext.insert(newFlashcard)
                            
                            withAnimation {
                                navigationPath.append(.flashcard(newFlashcard))
                            }
                        }
                    }
//                case .fl
                    // TODO: Change for proper implementations
                default:
                    EmptyView()
                }
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
    
    func toggleForm() {
        isFormPresented.toggle()
    }
    
    func selectFlashcard(_ flashCard: Flashcard) {
        withAnimation {
            navigationPath.append(.flashcard(flashCard))
        }
    }
}

#Preview("Empty") {
    HomeView()
        .modelContainer(for: Category.self, inMemory: true)
}

#Preview("Non empty") {
    MainActor.assumeIsolated {
        HomeView()
            .modelContainer(previewContainer)
    }
}
