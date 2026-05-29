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
                        EfficacyPill(efficacy: TypeStrength(name: pokemonType.type.name, id: pokemonType.type.id))
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

// #Preview(traits: .sizeThatFitsLayout) {
//    PokemonInfoHeaderView(
//        pokemonName: "Squirtle",
//        pokemonTypes: [PokemonType(id: 12, name: "grass", typeEfficaciesByTargetTypeId: [
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 10, name: "fire")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 15, name: "ice")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 3, name: "flying")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 7, name: "bug")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 11, name: "water")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 13, name: "electric")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 12, name: "grass"))
//        ]),
//        PokemonType(id: 12, name: "grass", typeEfficaciesByTargetTypeId: [
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 10, name: "fire")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 15, name: "ice")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 3, name: "flying")),
//            TypeEfficacy(damageFactor: 200, type: AttackerType(id: 7, name: "bug")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 11, name: "water")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 13, name: "electric")),
//            TypeEfficacy(damageFactor: 50, type: AttackerType(id: 12, name: "grass"))
//        ])],
//        accentColor: TypeColor.grass.color
//    )
//    .environment(SoundManager())
// }
