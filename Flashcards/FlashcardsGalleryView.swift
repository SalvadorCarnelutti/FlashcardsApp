//
//  FlashcardsGalleryView.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI
import SwiftData

struct FlashcardsGalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var flashcards: [Flashcard]
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @Bindable var collection: Collection
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State var isNewCategoryFormPresented: Bool = false
    
    let selectFlashcard: (Flashcard) -> Void
    let addFlashcard: () -> Void
    
    @State var isEditCategoryFormPresented: Bool = false
    
    init(collection: Collection, selectFlashcard: @escaping (Flashcard) -> Void, addFlashcard: @escaping () -> Void) {
        self.collection = collection
        self.selectFlashcard = selectFlashcard
        self.addFlashcard = addFlashcard
        
        // Workaround as of Xcode 15.6, SwiftData doesn't allow dynamic queries
        let collectionName = collection.name
        
        let predicate = #Predicate<Flashcard> {
            $0.collection.name == collectionName
        }
        
        _flashcards = Query(filter: predicate, sort: \Flashcard.prompt)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.clear)
                    LabeledContent("Category") {
                        Text(collection.category?.name ?? "None")
                    }
                }
                .padding()
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 3)
                .overlay(alignment: .top) {
                    Rectangle().frame(maxWidth: .infinity, maxHeight: 7, alignment: .top)
                        .foregroundColor(collection.flashcardBackgroundColor)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 7, topTrailingRadius: 7))
                }
                .onTapGesture {
                    isEditCategoryFormPresented = true
                }
            }
            .padding()
            
            LazyVGrid(columns: columns, spacing: 20) {
                // TODO: Card might not have a category remove force unwrapping
                CardGalleryItem(backgroundStyle: collection.flashcardBackgroundColor, action: addFlashcard) {
                    LabeledContent("Add Card") {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .labelsHidden()
                }
                .shadow(radius: 2)
                
                ForEach(flashcards) { flashcard in
                    CardGalleryItem(backgroundStyle: collection.flashcardBackgroundColor) {
                        selectFlashcard(flashcard)
                    } label: {
                        Text(flashcard.prompt)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditCategoryFormPresented) {
            NavigationStack {
                Form {
                    EditCollectionCategoryView(categories: categories,
                                               collection: collection,
                                               isNewCategoryFormPresented: $isNewCategoryFormPresented,
                                               addCategoryFormViewModel: AddCategoryFormViewModel())
                    .padding()

                }
            }
        }
        .navigationTitle(collection.name)
    }
}

#Preview {
    MainActor.assumeIsolated {
        FlashcardsGalleryView(collection: Collection(name: "Japanese"),
                              selectFlashcard: { _ in },
                              addFlashcard: {})
        .modelContainer(previewContainer)
    }
}

struct EditCollectionCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let categories: [Category]
    let collection: Collection
    
    @Binding var isNewCategoryFormPresented: Bool
    let addCategoryFormViewModel: AddCategoryFormViewModel
    @State var selectedIndex: Int
    
    @State var isCategoryAlertPresented: Bool = false
    
    init(categories: [Category],
         collection: Collection,
         isNewCategoryFormPresented: Binding<Bool>,
         addCategoryFormViewModel: AddCategoryFormViewModel) {
        self.categories = categories
        self.collection = collection
        self._isNewCategoryFormPresented = isNewCategoryFormPresented
        self.addCategoryFormViewModel = addCategoryFormViewModel
        self._selectedIndex = if let category = collection.category {
            State(initialValue: categories.firstIndex(of: category) ?? 0)
        } else {
            State(initialValue: 0)
        }
    }
    
    var body: some View {
        Group {
            if categories.isNotEmpty {
                ChooseCategoryPicker(selectedIndex: $selectedIndex,
                                     categories: categories)
            }
            Button(action: toggleNewCategory) {
                Text("Add new category")
            }
        }
        .sheet(isPresented: $isNewCategoryFormPresented) {
            AddCategoryFormView(isAlertPresented: $isCategoryAlertPresented,
                                isPresented: $isNewCategoryFormPresented,
                                addCategoryFormViewModel: addCategoryFormViewModel,
                                addCategory: addCategory)
            .presentationDetents([.medium])
            .padding()
        }
        .onChange(of: selectedIndex) {
            collection.category = categories[selectedIndex]
            dismiss()
        }
    }
    
    private func toggleNewCategory() {
        isNewCategoryFormPresented.toggle()
    }
    
    private func addCategory(category: Category) {
        guard !categories.map({ $0.name }).contains(category.name) else {
            isCategoryAlertPresented = true
            return
        }
        
        modelContext.insert(category)
        collection.category = category
        isNewCategoryFormPresented = false
        
        dismiss()
    }
}
