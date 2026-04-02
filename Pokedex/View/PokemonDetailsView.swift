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



struct PokemonInfoHeaderView: View {
    let id: Int
    let name: String
    let onFavoriteToggle: () -> Void
    let isFavorite: Bool
    let formattedGeneration: String

    var body: some View {
        VStack(spacing: 8) {
            Text("#\(String(format: "%03d", id))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                HStack {
                    Text(name.capitalized)
                        .font(
                            .system(
                                size: 44,
                                weight: .black,
                                design: .rounded
                            )
                        )
                    Button {
                        onFavoriteToggle()
                    } label: {
                        Image(
                            systemName: isFavorite
                                ? "heart.fill" : "heart"
                        )
                        .font(.system(size: 30))
                        .foregroundStyle(isFavorite ? .red : .gray)
                    }
                    .buttonStyle(.borderless)
                }
                Text(formattedGeneration)
                    .font(.system(size: 20))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
        }

    }
}

struct PokemonStatsView: View {
    let typeString: String
    let weight: Int
    let height: Int

    var body: some View {
        HStack(spacing: 40) {
            StatVStack(
                label: "Type",
                value: typeString,
                color: .orange
            )
            StatVStack(
                label: "Weight",
                value: "\(weight)",
                color: .blue
            )
            StatVStack(
                label: "Height",
                value: "\(height)",
                color: .green
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20).fill(
                Color(.systemBackground)
            ).shadow(radius: 5)
        )
    }
}

struct PokemonBattleStatsView: View {
    let pokemonHP: Int
    let pokemonAttack: Int
    let pokemonDefense: Int
    let pokemonSpeed: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Base Stats")
                .font(.title2)
                .bold()

            StatBar(
                label: "HP",
                value: pokemonHP,
                color: .green
            )
            StatBar(
                label: "ATK",
                value: pokemonAttack,
                color: .red
            )
            StatBar(
                label: "DEF",
                value: pokemonDefense,
                color: .blue
            )
            StatBar(
                label: "SPD",
                value: pokemonSpeed,
                color: .orange
            )
        }
        .padding()
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
