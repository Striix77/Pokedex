//
//  Pokemon+Mock.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import Foundation

@testable import Pokedex  // Replace with your actual App Name

extension Pokemon {
    static func mock(id: Int, name: String) -> Pokemon {
        return Pokemon(
            id: id,
            name: name,
            pokemontypes: [],
            pokemonspecy: <#T##SpeciesEntry?#>,
            weight:0,
            height:0,
            pokemonsprites: [],
            pokemonstats: [
                StatEntry(
                    base_stat: 50,
                    stat: StatDetails(name: "hp")
                )
            ],
        )
    }
}
