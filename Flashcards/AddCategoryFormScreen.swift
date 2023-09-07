//
//  AddCategoryFormView.swift
//  Flashcards
//
//  Created by Salvador on 8/14/23.
//

import SwiftUI
import SwiftData
import Observation

@Observable final class AddCategoryFormViewModel {
    var categoryName: String = ""
    var categoryColor = FlashcardColor.clear
    
    var getCategory: Category {
        Category(name: categoryName.capitalized, color: categoryColor.rawValue)
    }
}

struct AddCategoryFormScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State var isFormPresented: Bool = false
    @Binding var isAlertPresented: Bool
    
    @Bindable var addCategoryFormViewModel: AddCategoryFormViewModel
    @FocusState private var categoryNameFieldIsFocused: Bool
    
    let addCategory: ((Category) -> Void)
    
    var body: some View {
        HStack {
            Button("Add") {
                addCategory(addCategoryFormViewModel.getCategory)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .disabled(addCategoryFormViewModel.categoryName.isTrimmedEmpty)
        }
        TextField(text: $addCategoryFormViewModel.categoryName) {
            Text("Category name")
        }
        .focused($categoryNameFieldIsFocused)
        
        LabeledContent("Category color") {
            Text(addCategoryFormViewModel.categoryColor.rawValue.capitalized)
            
            if addCategoryFormViewModel.categoryColor != .clear {
                Image(systemName: "rectangle.fill")
                    .foregroundStyle(addCategoryFormViewModel.categoryColor.color)
            } else {
                EmptyView()
            }
        }
        
        Picker("Set color", selection: $addCategoryFormViewModel.categoryColor) {
            ForEach(FlashcardColor.allCases) { flashcardColor in
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
        
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            categoryNameFieldIsFocused = true
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Category name already exists"),
                  message: Text("Choose a different name"))
        }
    }
}

#Preview {
    AddCategoryFormScreen(isAlertPresented: .constant(false),
                          addCategoryFormViewModel: AddCategoryFormViewModel(),
                          addCategory: { _ in })
    .padding()
}

// TODO: Once SwiftData preview get fixed add preview
struct ChooseCategoryPicker: View {
    @Binding var selectedIndex: Int
    let categories: [Category]
    
    var body: some View {
        Picker("Select category", selection: $selectedIndex) {
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                HStack {
                    Text(category.name.capitalized)
                    // TODO: Maybe change in such a way I don't compare strings
                    if !category.isClearColored {
                        Image(systemName: "rectangle.fill")
                            .foregroundStyle(FlashcardColor(rawValue: category.colorName)!.color)
                    }
                }.tag(index)
            }
        }
        .id(categories)
        .pickerStyle(.navigationLink)
    }
}
