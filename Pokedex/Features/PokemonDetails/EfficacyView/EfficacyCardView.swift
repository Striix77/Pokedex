//
//  EfficacyCardView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//


import SwiftUI

struct EfficacyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    let efficacy: TypeStrength

    var body: some View {
        VStack {
            AsyncImage(url: EfficacyCardHelper.getIconUrl(for: efficacy.id)) { image in
                image
                    .image?.resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 56, height: 56)
            .shadow(radius: 4)
            Text(efficacy.name)

        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            EfficacyCardHelper.getBackgroundColor(for: efficacy, colorScheme: colorScheme)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
