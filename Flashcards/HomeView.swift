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
    @Query(sort: \Category.name) private var categories: [Category]
    @Query(filter: #Predicate<Collection> { $0.category == nil }) private var collections: [Collection]
    @State var isFormPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.collections) { collection in
                            HStack {
                                Text(collection.name)
//                                Image(systemName: "rectangle.fill")
//                                    .foregroundStyle(FlashcardColor(rawValue: category.color)!.color)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    } header: {
                        HStack{
                            Text(category.name)
                            Image(systemName: "rectangle.fill")
                                .foregroundStyle(FlashcardColor(rawValue: category.color)!.color)
                        }

                    }
                }
                
                Section {
                    ForEach(collections) { collection in
                        HStack {
                            Text(collection.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
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
            .navigationTitle("Home")
            .overlay {
                if categories.isEmpty {
                    ContentUnavailableView {
                        Label("No flashcards at the moment", systemImage: "rectangle.slash")
                    } description: {
                        Text("Start adding on the top-right")
                    }
                }
            }
            .sheet(isPresented: $isFormPresented, content: {
                AddCollectionFormView(addCollectionFormViewModel: AddCollectionFormViewModel())
//                AddCategoryFormView(addCategoryFormViewModel: AddCategoryFormViewModel())
            })
            Text("Select a flashcard")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
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
