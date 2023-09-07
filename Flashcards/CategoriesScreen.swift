//
//  CategoriesScreen.swift
//  Flashcards
//
//  Created by Salvador on 9/7/23.
//

import SwiftUI
import SwiftData

struct CategoriesScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State var isFormPresented: Bool = false
    @State var isCategoryAlertPresented: Bool = false
    
    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    Text(category.name.capitalized)
                    Image(systemName: "rectangle.fill")
                        .foregroundStyle(FlashcardColor(rawValue: category.colorName)!.color)
                }
            }
            .onDelete { indexSet in
                deleteCategories(offsets: indexSet)
            }
        }
        .navigationTitle("Categories")
        .overlay {
            if categories.isEmpty {
                ContentUnavailableView {
                    Label("No categories at the moment", systemImage: "tag.slash")
                } description: {
                    Text("Start adding on the top-right")
                }
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
        .sheet(isPresented: $isFormPresented) {
            AddCategoryFormView(isAlertPresented: $isCategoryAlertPresented,
                                addCategoryFormViewModel: AddCategoryFormViewModel(),
                                addCategory: addCategory)
            .presentationDetents([.medium])
            .padding()
        }
    }
    
    private func addCategory(category: Category) {
        guard !categories.map({ $0.name }).contains(category.name) else {
            isCategoryAlertPresented = true
            return
        }
        
        modelContext.insert(category)
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
    
    private func toggleForm() {
        isFormPresented.toggle()
    }
}

#Preview {
    CategoriesScreen()
}
