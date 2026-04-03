//
//  PokemonBattleStatsView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct PokemonBattleStatsView: View {
    let pokemonHP: Int
    let pokemonAttack: Int
    let pokemonDefense: Int
    let pokemonSpeed: Int
    let pokemonTypes: [PokemonTypes]
    let allTypes: [PokemonType]

    var body: some View {
        VStack {
            PokemonBaseStatsView(
                pokemonHP: pokemonHP,
                pokemonAttack: pokemonAttack,
                pokemonDefense: pokemonDefense,
                pokemonSpeed: pokemonSpeed
            )
        }
    }
    
            )

            )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PokemonBattleStatsView(
        pokemonHP: 100,
        pokemonAttack: 90,
        pokemonDefense: 80,
        pokemonSpeed: 70,
        pokemonTypes: [],
        allTypes: []
    )
}
