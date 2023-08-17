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
        Collection(name: collectionName)
    }
}

struct AddCollectionFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var collections: [Collection]
    @State private var isAlertPresented: Bool = false
    
    @Bindable var addCollectionFormViewModel: AddCollectionFormViewModel
    @FocusState private var collectionNameFieldIsFocused: Bool
    
    var body: some View {
        Form {
            Section("Name") {
                TextField(text: $addCollectionFormViewModel.collectionName) {
                    Text("Collection name")
                }
                .focused($collectionNameFieldIsFocused)
            }
            
            Button(action: addCollection) {
                Text("Add collection")
            }
            .disabled(addCollectionFormViewModel.collectionName.isEmpty)
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Category name already exists"),
                  message: Text("Choose a different name"))
        }
        .onAppear {
            collectionNameFieldIsFocused = true
        }
    }
    
    func addCollection() {
        let model = addCollectionFormViewModel.getCollection
        
        guard !collections.map({ $0.name }).contains(model.name) else {
            isAlertPresented = true
            return
        }
        
        modelContext.insert(model)
        dismiss()
    }
}

#Preview {
    AddCollectionFormView(addCollectionFormViewModel: AddCollectionFormViewModel())
}
