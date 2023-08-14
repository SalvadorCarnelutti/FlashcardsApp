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
    @Query(sort: \.name) private var categories: [Category]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Text(category.name)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: AddFlashcardView(addFlashcardViewModel: AddFlashcardViewModel())) {
                        Label("Add category", systemImage: "plus")
                    }
                }
            }
            .overlay {
                if categories.isEmpty {
                    ContentUnavailableView {
                        Label("No flashcards at the moment", systemImage: "rectangle.slash")
                    } description: {
                        Text("Start adding on the top-right")
                    }
                }
            }
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
}

#Preview {
    HomeView()
        .modelContainer(for: Category.self, inMemory: true)
}
