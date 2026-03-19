//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SDWebImageSwiftUI
import SwiftUI

struct PokemonDetailsView: View {
    let pokemon: Pokemon
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @State private var didFail = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //Image Header
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 260, height: 260)

                    if didFail {
                        Image("missingno")
                            .resizable()
                            .frame(width: 250, height: 250)
                    } else {
                        WebImage(url: pokemon.spriteURL)
                            .onSuccess { image, data, cacheType in
                                print(
                                    "Loaded from: \(cacheType == .disk ? "Disk" : "Network")"
                                )
                            }
                            .onFailure { error in
                                print(
                                    "Image failed to load: \(error.localizedDescription)"
                                )
                                DispatchQueue.main.async {
                                    self.didFail = true
                                }
                            }
                            .resizable()
                            .indicator(.activity)
                            .frame(width: 250, height: 250)
                    }

                }
                .padding(.top, 30)

                //ID, name, favorite, generation
                VStack(spacing: 8) {
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    VStack(spacing:10) {
                        HStack {
                            Text(pokemon.name.capitalized)
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
                        Text(pokemon.formattedGeneration)
                            .font(.system(size: 20))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                }

                //Info Stats
                HStack(spacing: 40) {
                    StatVStack(
                        label: "Type",
                        value: pokemon.typeString,
                        color: .orange
                    )
                    StatVStack(
                        label: "Weight",
                        value: "\(pokemon.weight)",
                        color: .blue
                    )
                    StatVStack(
                        label: "Height",
                        value: "\(pokemon.height)",
                        color: .green
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(
                        Color(.systemBackground)
                    ).shadow(radius: 5)
                )

                // Pokémon Stats
                VStack(alignment: .leading, spacing: 10) {
                    Text("Base Stats")
                        .font(.title2)
                        .bold()

                    StatBar(
                        label: "HP",
                        value: pokemon.statValue(named: "hp"),
                        color: .green
                    )
                    StatBar(
                        label: "ATK",
                        value: pokemon.statValue(named: "attack"),
                        color: .red
                    )
                    StatBar(
                        label: "DEF",
                        value: pokemon.statValue(named: "defense"),
                        color: .blue
                    )
                    StatBar(
                        label: "SPD",
                        value: pokemon.statValue(named: "speed"),
                        color: .orange
                    )
                }
                .padding()

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
