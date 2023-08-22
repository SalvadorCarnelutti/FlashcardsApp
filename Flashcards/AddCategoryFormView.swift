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

struct AddCategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State var isFormPresented: Bool = false
    @Binding var isAlertPresented: Bool
    @Binding var isPresented: Bool
    
    @Bindable var addCategoryFormViewModel: AddCategoryFormViewModel
    @FocusState private var categoryNameFieldIsFocused: Bool
    
    let addAction: ((Category) -> Void)
    
    var body: some View {
        HStack {
            Button("Add") {
                addAction(addCategoryFormViewModel.getCategory)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .disabled(addCategoryFormViewModel.categoryName.isEmpty)
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

//#Preview {
//    AddCategoryFormView(addCategoryFormViewModel: AddCategoryFormViewModel())
//}

// TODO: Once SwiftData preview get fixed add preview
struct ChooseCategoryPicker: View {
    let selectedIndex: Binding<Int>
    let categories: [Category]
    
    var body: some View {
        Picker("Select category", selection: selectedIndex) {
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                HStack {
                    Text(category.name.capitalized)
                    Image(systemName: "rectangle.fill")
                        .foregroundStyle(FlashcardColor(rawValue: category.color)!.color)
                }.tag(index)
            }
        }.id(categories)
            .pickerStyle(.navigationLink)
    }
}
