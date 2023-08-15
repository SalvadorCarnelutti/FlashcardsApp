//
//  AddCategoryForm.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import SwiftData

struct AddCategoryForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State private var isAlertPresented: Bool = false
    @State private var categoryName: String = ""
    @State private var categoryColor = FlashcardColor.clear
    
    var body: some View {
        Form {
            Section("Name") {
                TextField(text: $categoryName) {
                    Text("Category name")
                }
            }
            
            Section("Card's associated color") {
                Picker("Set color", selection: $categoryColor) {
                    ForEach(FlashcardColor.allCases, id: \.self) { flashcardColor in
                        HStack() {
                            if flashcardColor == .clear {
                                Text(flashcardColor.rawValue.capitalized)
                            } else {
                                Text(flashcardColor.rawValue.capitalized)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Image(systemName: "rectangle.fill")
                                    .foregroundStyle(flashcardColor.color)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .pickerStyle(.wheel)

            }
            
            Button(action: addCategory) {
                Text("Add category")
            }
            .disabled(categoryName.isEmpty)
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Category name already exists"),
                  message: Text("Choose a different name"))
        }
    }
    
    func addCategory() {
        guard !categories.map({ $0.name }).contains(categoryName) else {
            isAlertPresented = true
            return
        }
        
        let model = Category(name: categoryName, color: categoryColor.rawValue)
        modelContext.insert(model)
        dismiss()
    }
}

#Preview {
    AddCategoryForm()
}
