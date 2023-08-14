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

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        /*
         If you have models that have relationships with each other, you only need to specify one model class and the container will infer the related model classes.
         There is a one-to-many relationship between Category and Collection.
         */
        .modelContainer(for: Category.self)
    }
}
