//
//  AddCollectionFormView.swift
//  Flashcards
//
//  Created by Salvador on 8/15/23.
//

import SwiftUI
import SwiftData
import Observation

@Observable final class AddCollectionFormViewModel {
    var collectionName: String = ""
    
    var getCollection: Collection {
        Collection(name: collectionName.capitalized)
    }
    
    func getCollection(for category: Category) -> Collection {
        Collection(name: collectionName.capitalized, category: category)
    }
}

struct AddCollectionFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var collections: [Collection]
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var addCollectionFormViewModel = AddCollectionFormViewModel()
    private var addCategoryFormViewModel = AddCategoryFormViewModel()
    @FocusState private var collectionNameFieldIsFocused: Bool
            
    @State var skipsCategory: Bool = false
    @State var selectedIndex: Int = 0
    @State var isNewCategoryFormPresented: Bool = false
    @State var isCollectionAlertPresented: Bool = false
    @State var isCategoryAlertPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField(text: $addCollectionFormViewModel.collectionName) {
                        Text("Collection name")
                    }
                    .focused($collectionNameFieldIsFocused)
                }
                
                Section("Category (Optional)") {
                    if categories.isNotEmpty {
                        Toggle("Skip", isOn: $skipsCategory)
                    }
                    Group {
                        if categories.isNotEmpty {
                            ChooseCategoryPicker(selectedIndex: $selectedIndex,
                                                 categories: categories)
                        }
                        Button(action: toggleNewCategory) {
                            Text("Add new category")
                        }
                    }
                    .disabled(skipsCategory)
                }
                
                Button(action: addCollection) {
                    Text("Add collection")
                }
                .disabled(addCollectionFormViewModel.collectionName.isEmpty)
            }
            .onAppear {
                collectionNameFieldIsFocused = true
            }
            .alert(isPresented: $isCollectionAlertPresented) {
                Alert(title: Text("Collection name already exists"),
                      message: Text("Choose a different name"))
            }
            .sheet(isPresented: $isNewCategoryFormPresented) {
                AddCategoryFormView(isAlertPresented: $isCategoryAlertPresented,
                                    isPresented: $isNewCategoryFormPresented,
                                    addCategoryFormViewModel: addCategoryFormViewModel,
                                    addAction: addCategory)
                .presentationDetents([.medium])
                .padding()
            }
        }
    }
    
    private func addCategory(category: Category) {
        guard !categories.map({ $0.name }).contains(category.name) else {
            isCategoryAlertPresented = true
            return
        }
        
        modelContext.insert(category)
        
        // Insertion is not immediate, collections take a moment to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 , execute: {
            selectedIndex = categories.firstIndex(of: category) ?? 0
        })
        isNewCategoryFormPresented = false
    }
    
    private func toggleNewCategory() {
        isNewCategoryFormPresented.toggle()
    }
    
    private func addCollection() {
        guard !collections.map({ $0.name }).contains(where: { $0.caseInsensitiveCompare(addCollectionFormViewModel.collectionName) == .orderedSame }) else {
            isCollectionAlertPresented = true
            return
        }
        
        if skipsCategory || categories.isEmpty {
            modelContext.insert(addCollectionFormViewModel.getCollection)
        } else {
            let category = categories[selectedIndex]
            modelContext.insert(category)
            modelContext.insert(addCollectionFormViewModel.getCollection(for: category))
        }
        
        dismiss()
    }
}

#Preview {
    AddCollectionFormView()
}
