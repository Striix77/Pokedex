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

    var total: Int {
        details.stats.total
    }

    var body: some View {
        VStack(spacing: 48) {
            HexStatGrid(stats: details.stats, accentColor: accentColor)
                .frame(height: 300)
                .padding(20)
                .padding(.top, 20)

            statsTotal
        }
        .padding()
    }

    private var statsTotal: some View {
        VStack {
            Text("TOTAL")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("\(total)")
                .font(.title2)
                .bold()
                .foregroundStyle(accentColor)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.containerBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.containerBorder, lineWidth: 1)
                )
        )
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mock,
            types: PokemonType.mockTypes
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
