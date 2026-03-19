//
//  PokemonQueries.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import Foundation

struct PokemonQueries {
    static let getPokemonList = """
        query getPokemon {
          pokemon {
            id
            name
            pokemonspecy {
              generation {
                name
              }
            }
            pokemontypes{
              type{
                name
              }
            }
            weight
            height
            pokemonsprites {
                  sprites
                }
            pokemonstats {
                base_stat
                stat {
                    name
              }
            }
          }
        }
        """
}
