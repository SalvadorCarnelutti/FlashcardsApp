//
//  Router.swift
//  Flashcards
//
//  Created by Salvador on 8/25/23.
//

import SwiftUI

final class Router: ObservableObject {
    public enum Route: Hashable {
        case flashcardsGalleryView(Deck)
        case flashcardCarousel(FlashcardCarouselViewModel)
        case category(Category)
        case deck(Deck)
        case flashcard(Flashcard)
    }
    
    @Published var navigationPathPath = NavigationPath()
    
    func navigate(to route: Route) {
        navigationPathPath.append(route)
    }
    
    func navigateBack() {
        navigationPathPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPathPath.removeLast(navigationPathPath.count)
    }
}
