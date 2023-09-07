//
//  CardGalleryItemView.swift
//  Flashcards
//
//  Created by Salvador on 8/16/23.
//

import SwiftUI

import SwiftUI

struct CardGalleryItemView<Content: View, S: ShapeStyle>: View {
    let backgroundStyle: S
    let action: () -> Void
    @ViewBuilder var label: Content

    var body: some View {
        Button(action: action) {
            CardContainerView {
                label
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
        }
        .backgroundStyle(backgroundStyle)
        .buttonStyle(.plain)
        .padding()
    }
}
