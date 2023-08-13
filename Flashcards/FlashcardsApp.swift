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
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
