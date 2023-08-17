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
    @FocusState private var categoryNameFieldIsFocused: Bool
    
    var body: some View {
        Form {
            Section() {
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
                .onTapGesture {
                    withAnimation {
                        showsPicker.toggle()
                    }
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
                        withAnimation {
                            showsPicker.toggle()
                        }
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
        .onAppear {
            categoryNameFieldIsFocused = true
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
