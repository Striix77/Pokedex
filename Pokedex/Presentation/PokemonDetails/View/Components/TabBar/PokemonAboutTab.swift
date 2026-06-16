//
//  PokemonAboutTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonAboutTab: View {
    let pokemonListEntry: PokemonListEntry
    let types: [PokemonType]
    let details: PokemonDetailsEntry

    private let strongEfficacyTitle = "Strong against"
    private let weakEfficacyTitle = "Weak against"
    private let strongEfficacyValues = [0, 50]
    private let weakEfficacyValues = [0, 200]
    private let noEfficacyLabel = "Other stats to be discovered..."
    private let contentSpacing: CGFloat = 32

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonListEntry.pokemontypes,
            allTypes: types
        )
    }

    private var strengthEfficacies: [TypeStrength]? {
        calculator.calculateEfficacies(for: strongEfficacyValues)
    }

    private var weaknessEfficacies: [TypeStrength]? {
        calculator.calculateEfficacies(for: weakEfficacyValues)
    }

    private var description: String {
        details.pokemonspecy?.flavorText ?? "The origins of this Pokémon are unknown..."
    }

    var body: some View {
        VStack(spacing: contentSpacing) {
            descriptionText

            PokemonStatsView(
                weight: details.weight,
                height: details.height,
                category: details.pokemonspecy?.genus
            )

            efficacyViews
        }
    }

    private var descriptionText: some View {
        HStack {
            Text(description)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var efficacyViews: some View {
        VStack {
            if let efficacies = strengthEfficacies {
                EfficacyView(title: strongEfficacyTitle, efficacies: efficacies)
            } else {
                noEfficacySubview
            }
            if let efficacies = weaknessEfficacies {
                EfficacyView(title: weakEfficacyTitle, efficacies: efficacies)
            } else if strengthEfficacies != nil {
                noEfficacySubview
            }
        }
    }

    private var noEfficacySubview: some View {
        Text(noEfficacyLabel)
            .font(.title3)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.noEfficacyBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockBulbasaur,
            types: PokemonType.mockBulbasaurTypes
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
