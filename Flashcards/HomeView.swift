//
//  HomeView.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Category> { $0.decks.count > 0 }, sort: \Category.name) private var categories: [Category]
    @Query(filter: #Predicate<Deck> { $0.category == nil }) private var decks: [Deck]
    @State var isFormPresented: Bool = false
    
    @EnvironmentObject var router: Router
    
    var body: some View {
            List {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.decks) { deck in
                            NavigationLink(value: Router.Route.flashcardsGalleryView(deck)) {
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
                        NavigationLink(deck.name, value: Router.Route.flashcardsGalleryView(deck))
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
