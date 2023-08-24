//
//  FlashcardModels.swift
//  Flashcards
//
//  Created by Salvador on 8/13/23.
//

import SwiftData
import SwiftUI

// SwiftData enhances the model by automatically conferring it the PersistentModel conformance. This means that your model is now Identifiable, Observable, and Hashable.
@Model
final class Category {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var collections: [Collection]
    let colorName: String
    
    init(name: String, collections: [Collection] = [], color: String) {
        self.name = name
        self.collections = collections
        self.colorName = color
    }
}

@Model
final class Collection {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var flashcards: [Flashcard]
    var category: Category?
    
    init(name: String, flashcards: [Flashcard] = [], category: Category? = nil) {
        self.name = name
        self.flashcards = flashcards
        self.category = category
    }
    
    @Transient var color: Color {
        guard let category = category else { return .clear }
        
        return FlashcardColor(rawValue: category.colorName)?.color ?? .clear
    }
    
    @Transient var flashcardBackgroundColor: Color {
        guard let category = category, category.colorName != "clear" else { return .flashcardsTheme }
        
        return FlashcardColor(rawValue: category.colorName)?.color ?? .flashcardsTheme
    }
    
    func addFlashcard(_ flashcard: Flashcard) { flashcards.append(flashcard) }
}

@Model
final class Flashcard {
    var prompt: String
    var answer: String
    var collection: Collection
    
    init(prompt: String, answer: String, collection: Collection) {
        self.prompt = prompt
        self.answer = answer
        self.collection = collection
    }
}

// Lista de categorias como secciones y colleciones como filas. Tocar la fila es entrar a las flashcards de esa coleccion
// Entrar a una fila es mostrar collection view como la de WWDC (La primera tarjeta es un add, y las restantes son las ya creadas)
// El add en el home debería ser para agregar una collecion
