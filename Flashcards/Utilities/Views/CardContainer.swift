//
//  CardContainer.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI

/// A container for card content
struct CardContainerView<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
            content
        }
        .aspectRatio(2, contentMode: .fit)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
