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

    let pokemonName: String

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 12) {
                pokemonTitle

                VStack(spacing: 12) {
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
        pokemonName: "Squirtle"
    )
}
