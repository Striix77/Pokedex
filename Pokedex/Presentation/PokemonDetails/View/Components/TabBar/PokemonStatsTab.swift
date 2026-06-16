//
//  PokemonStatsTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonStatsTab: View {
    let details: PokemonDetailsEntry
    let accentColor: Color

    private let gridHeight: CGFloat = 300
    private let gridPadding: CGFloat = 20
    private let contentSpacing: CGFloat = 48
    private let totalLabelPadding: CGFloat = 20
    private let totalContainerCornerRadius: CGFloat = 22
    private let totalContainerBorderWidth: CGFloat = 1
    private let totalLabel = "TOTAL"

    private var total: Int {
        details.stats.total
    }

    var body: some View {
        VStack(spacing: contentSpacing) {
            HexStatGrid(stats: details.stats, accentColor: accentColor)
                .frame(height: gridHeight)
                .padding(gridPadding)
                .padding(.top, gridPadding)

            statsTotal
        }
        .padding()
    }

    private var statsTotal: some View {
        VStack {
            Text(totalLabel)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("\(total)")
                .font(.title2)
                .bold()
                .foregroundStyle(accentColor)
        }
        .padding(totalLabelPadding)
        .frame(maxWidth: .infinity)
        .containerBackground(cornerRadius: totalContainerCornerRadius, lineWidth: totalContainerBorderWidth)
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockBulbasaur,
            types: PokemonType.mockBulbasaurTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Squirtle") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockSquirtle,
            types: PokemonType.mockSquirtleTypes
        )
        .environment(SoundManager())
    }
}
