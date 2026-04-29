//
//  PokemonGridCard.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//
import SwiftUI

struct PokemonGridCard: View {
    @State private var ringStopLocation:CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    let pokemon: PokemonListEntry

    private var typeColors: (Color?, Color?) {
        var colors = TypeColor.getDoubleTypeColors(for: pokemon, scheme: colorScheme)
        colors.0 = colors.0?.opacity(3)
        colors.1 = colors.1?.opacity(3)
        return colors
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray).opacity(0.1)

            GlowingRing(colors: typeColors)
                .padding(12)

            mainContent
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
    }

    private var mainContent: some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
            Text("#\(pokemon.id)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(pokemon.name.capitalized)
                .bold()
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .foregroundStyle(Color.mainFont)
    }
}
