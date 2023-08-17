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
    
    let selectFlashcard: (Flashcard) -> Void
    let addFlashcard: () -> Void
    
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
                // TODO: Switch for proper view to select previous category or set a new one
                NavigationLink(value: Route.collection(collection)) {
                    LabeledContent("Category") {
                        Text(collection.category?.name ?? "None")
                    }
                }
            }
            .padding()
            
            LazyVGrid(columns: columns, spacing: 20) {
                CardGalleryItem(backgroundStyle: .cyan, action: addFlashcard) {
                    LabeledContent("Add Card") {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .labelsHidden()
                }
                .shadow(radius: 2)
                
                ForEach(flashcards) { flashcard in
                    CardGalleryItem(backgroundStyle: .cyan) {
                        selectFlashcard(flashcard)
                    } label: {
                        Text(flashcard.prompt)
                    }
                }
            }
        }
        .navigationTitle(collection.name)
    }
}

//#Preview {
//    FlashcardsGalleryView(collection: Collection(name: "Japanese"))
//}

//#Preview {
//    MainActor.assumeIsolated {
//        FlashcardsGalleryView(collection: Collection(name: "Prueba"), selectFlashcard: { fllashcard in
//            
//        }, addFlashcard: {})
//            .modelContainer(previewContainer)
//    }
//}
