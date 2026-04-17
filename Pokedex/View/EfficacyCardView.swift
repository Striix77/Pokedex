//
//  EfficacyCardView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//


import SwiftUI

struct EfficacyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let efficacy: TypeStrength
    let iconURL: URL?

    var body: some View {
        VStack {
            //TODO: Replace with Kingfisher
            AsyncImage(url: iconURL) { image in
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
            TypeColor.getSafeColor(for: efficacy.name, scheme: colorScheme)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
