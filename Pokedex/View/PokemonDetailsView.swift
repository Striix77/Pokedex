//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
    let pokemon: Pokemon
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PokemonImageView(spriteURL: pokemon.spriteURL)
                PokemonInfoHeaderView(
                    id: pokemon.id,
                    name: pokemon.name,
                    onFavoriteToggle: onFavoriteToggle,
                    isFavorite: isFavorite,
                    formattedGeneration: pokemon.formattedGeneration
                )
                PokemonStatsView(
                    typeString: pokemon.typeString,
                    weight: pokemon.weight,
                    height: pokemon.height
                )
                PokemonBattleStatsView(
                    pokemonHP: pokemon.statValue(named: "hp"),
                    pokemonAttack: pokemon.statValue(named: "attack"),
                    pokemonDefense: pokemon.statValue(named: "defense"),
                    pokemonSpeed: pokemon.statValue(named: "speed")
                )

                Spacer()
            }
            .padding()
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}


struct StatVStack: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct StatBar: View {
    let label: String
    let value: Int
    let maxValue: Double = 255
    let color: Color

    var body: some View {
        HStack {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 50, alignment: .leading)

            Text("\(value)")
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 35)

            // The actual visual bar
            ProgressView(value: Double(value), total: maxValue)
                .tint(color)
        }
    }
}
