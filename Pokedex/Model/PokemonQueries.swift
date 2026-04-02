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
    
    static let pokemonTypesList = """
        query samplePokeAPIquery {
          type{
              name
              TypeefficaciesByTargetTypeId(where: {damage_factor: {_neq: 100}}) {
                  damage_factor
                  type {
                      name
                  }
              }
          }
        }
        """
}
