//
//  HomeView.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftUI
import SwiftData

enum Route: Hashable {
    case flashcardsGalleryView(Collection)
    case category(Category)
    case collection(Collection)
    case flashcard(Flashcard)
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Category> { $0.collections.count > 0 }, sort: \Category.name) private var categories: [Category]
    @Query(filter: #Predicate<Collection> { $0.category == nil }) private var collections: [Collection]
    @State var isFormPresented: Bool = false
    
    @State private var navigationPath: [Route] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.collections) { collection in
                            NavigationLink(value: Route.flashcardsGalleryView(collection)) {
                                Text(collection.name.capitalized)
                            }
                        }
                        .onDelete { indexSet in
                            deleteCategoryCollections(category: category, offsets: indexSet)
                        }
                    } header: {
                        HStack{
                            Text(category.name.capitalized)
                            Image(systemName: "rectangle.fill")
                                .foregroundStyle(FlashcardColor(rawValue: category.color)!.color)
                        }
                    }
                }
                
                Section {
                    ForEach(collections) { collection in
                        NavigationLink(collection.name, value: Route.flashcardsGalleryView(collection))
                    }
                    .onDelete(perform: deleteCollections)
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
            // TODO: Maybe rename Collection to deck
            .navigationTitle("Decks")
            .overlay {
                if categories.isEmpty && collections.isEmpty {
                    ContentUnavailableView {
                        Label("No flashcards at the moment", systemImage: "rectangle.slash")
                    } description: {
                        Text("Start adding on the top-right")
                    }
                }
            }
            .sheet(isPresented: $isFormPresented) {
                AddCollectionFormView()
//                AddCategoryFormView(addCategoryFormViewModel: AddCategoryFormViewModel(), addAction: { _ in })
//                    .presentationDetents([.medium])
//                    .padding()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .flashcardsGalleryView(collection):
                    FlashcardsGalleryView(collection: collection,
                                          selectFlashcard: selectFlashcard) {
                        withAnimation {
                            let newFlashcard = Flashcard(prompt: "Sample Front",
                                                         answer: "Sample Back",
                                                         collection: collection)
                            collection.addFlashcard(newFlashcard)
                            modelContext.insert(newFlashcard)
                            
                            withAnimation {
                                navigationPath.append(.flashcard(newFlashcard))
                            }
                        }
                    }
                    // TODO: Change for proper implementations
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func deleteCategoryCollections(category: Category, offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(category.collections[index])
            }
        }
    }
    
    private func deleteCollections(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(collections[index])
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
