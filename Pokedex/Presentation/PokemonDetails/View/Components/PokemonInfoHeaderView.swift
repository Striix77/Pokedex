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
    let pokemonTypes: [PokemonTypes]
    let accentColor: Color

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 12) {
                pokemonTitle
                HStack {
                    ForEach(pokemonTypes, id: \.type.id) { pokemonType in
                        EfficacyPill(
                            efficacy: TypeStrength(
                                name: pokemonType.type.name.uppercased(), id: pokemonType.type.id
                            ),
                            iconCornerRadius: 22,
                            pillVerticalPadding: 8,
                            pillCornerRadius: 22
                        )
                    }

                    Spacer()

                    if canPlay {
                        soundPlayButton
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
            Image(systemName: "waveform")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(8)
                .foregroundStyle(accentColor)
                .background(
                    accentColor
                        .opacity(0.3)
                        .clipShape(Circle())
                )
                .overlay(
                    Circle()
                        .stroke(accentColor, lineWidth: 2)
                )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PokemonInfoHeaderView(
        pokemonName: PokemonListEntry.mockBulbasaur.name,
        pokemonTypes: PokemonListEntry.mockBulbasaur.pokemontypes,
        accentColor: TypeColor.grass.color
    )
    .environment(SoundManager())
}
