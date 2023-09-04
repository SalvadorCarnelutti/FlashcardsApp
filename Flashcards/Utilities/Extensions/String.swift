//
//  String.swift
//  Flashcards
//
//  Created by Salvador on 8/18/23.
//

import Foundation

extension String {
    var whitespacesTrimmed: String { trimmingCharacters(in: .whitespaces) }
    var isTrimmedEmpty: Bool { whitespacesTrimmed.isEmpty }
    var isNotEmpty: Bool { !isEmpty }
}
