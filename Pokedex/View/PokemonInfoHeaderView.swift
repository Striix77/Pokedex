import AVFoundation
//
//  PokemonInfoHeaderView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI

struct PokemonInfoHeaderView: View {
    @State private var soundManager = SoundManager()
    @State private var canPlay = false

    let id: Int
    let name: String
    let onFavoriteToggle: () -> Void
    let isFavorite: Bool
    let formattedGeneration: String
    let pokemonName: String

    var body: some View {
        VStack(spacing: 8) {
            Text("#\(String(format: "%03d", id))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                pokemonTitle

                VStack(spacing: 12) {
                    generationText
                    if canPlay {
                        soundPlayButton
                    }

                }
                .task {
                    canPlay = await soundManager.canPlaySound(of: pokemonName)
                }
            }
        }

    }

    private var pokemonTitle: some View {
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
    }

    private var generationText: some View {
        Text(formattedGeneration)
            .font(.system(size: 20))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
    }

    private var soundPlayButton: some View {

        return Button {
            soundManager.playCry(name: pokemonName)
        } label: {
            Image("PlayButton")
                .resizable()
                .frame(width: 40, height: 40)
        }

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PokemonInfoHeaderView(
        id: 1,
        name: "Squirtle",
        onFavoriteToggle: {

        },
        isFavorite: false,
        formattedGeneration: "Gen I",
        pokemonName: "Squirtle"
    )
}
