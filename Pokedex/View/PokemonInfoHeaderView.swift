//
//  PokemonInfoHeaderView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI

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
