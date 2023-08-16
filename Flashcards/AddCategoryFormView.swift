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
        Category(name: categoryName, color: categoryColor.rawValue)
    }
}

struct AddCategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State private var isAlertPresented: Bool = false
    @State var showsPicker: Bool = false
    
    @Bindable var addCategoryFormViewModel: AddCategoryFormViewModel
    
    var body: some View {
        Form {
            Section() {
                TextField(text: $addCategoryFormViewModel.categoryName) {
                    Text("Category name")
                }
                
                LabeledContent("Category color") {
                    if addCategoryFormViewModel.categoryColor != .clear {
                        Text(addCategoryFormViewModel.categoryColor.rawValue.capitalized)
                        Image(systemName: "rectangle.fill")
                            .foregroundStyle(addCategoryFormViewModel.categoryColor.color)
                    } else {
                        Text(addCategoryFormViewModel.categoryColor.rawValue.capitalized)
                    }
                }
                .onTapGesture {
                    showsPicker.toggle()
                }
                if showsPicker {
                    Picker("Set color", selection: $addCategoryFormViewModel.categoryColor) {
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
                    
                    Button("Done") {
                        showsPicker.toggle()
                    }
                    .buttonStyle(.borderless)
                }
            }
            
            Button(action: addCategory) {
                Text("Add category")
            }
            .disabled(addCategoryFormViewModel.categoryName.isEmpty)
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Collection name already exists"),
                  message: Text("Choose a different name"))
        }
    }
    
    func addCategory() {
        let model = addCategoryFormViewModel.getCategory
        
        guard !categories.map({ $0.name }).contains(model.name) else {
            isAlertPresented = true
            return
        }
        
        modelContext.insert(model)
        dismiss()
    }
}

#Preview {
    AddCategoryFormView(addCategoryFormViewModel: AddCategoryFormViewModel())
}
