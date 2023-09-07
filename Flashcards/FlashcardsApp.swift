//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftUI
import SwiftData

@main
struct FlashcardsApp: App {
    @StateObject var router = Router()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $router.navigationPath) {
                    DecksScreen()
                        .navigationDestination(for: Router.Route.self) { route in
                            switch route {
                            case let .flashcardsGalleryView(deck):
                                DeckGalleryScreen(deck: deck)
                            case let .flashcardCarousel(flashcardCarouselViewModel):
                                FlashcardCarouselScreen(flashcardCarouselViewModel: flashcardCarouselViewModel)
                                // TODO: Change for proper implementations
                            case let .flashcard(flashcard):
                                FlashcardView(flashcard: flashcard)
                            default:
                                EmptyView()
                            }
                        }
                }
                .tabItem {
                    Label("Decks", systemImage: "rectangle.stack.fill")
                }
                
                NavigationStack(path: $router.navigationPath) {
                    CategoriesScreen()
                }
                .tabItem {
                    Label("Categories", systemImage: "tag.fill")
                }
            }
            .environmentObject(router)
        }
        /*
         If you have models that have relationships with each other, you only need to specify one model class and the container will infer the related model classes.
         There is a one-to-many relationship between Category and Deck.
         */
        .modelContainer(for: Category.self)
    }
}
