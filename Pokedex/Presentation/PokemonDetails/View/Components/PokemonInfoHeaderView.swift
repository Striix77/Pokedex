//
//  PokemonInfoHeaderView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI

struct PokemonInfoHeaderView: View {
    @Environment(SoundManager.self) var soundManager
    @State private var canPlay = false

    let id: Int
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
            Text(pokemonName.capitalized)
                .font(
                    .system(
                        size: 44,
                        weight: .black,
                        design: .rounded
                    )
                )
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
        formattedGeneration: "Gen I",
        pokemonName: "Squirtle"
    )
}
