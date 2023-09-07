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
                DecksScreen()
                    .tabItem {
                        Label("Decks", systemImage: "rectangle.stack.fill")
                    }
                
                CategoriesScreen()
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
