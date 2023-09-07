//
//  Router.swift
//  Flashcards
//
//  Created by Salvador on 8/25/23.
//

import SwiftUI

final class Router: ObservableObject {
    public enum Route: Hashable {
        case deckGalleryScreen(Deck)
        case flashcardsCarouselScreen(FlashcardsCarouselViewModel)
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
