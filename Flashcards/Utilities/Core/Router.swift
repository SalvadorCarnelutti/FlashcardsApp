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
    
    @Published var navigationPath = NavigationPath()
    
    func navigate(to route: Route) {
        navigationPath.append(route)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
