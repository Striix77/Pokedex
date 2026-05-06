//
//  PokemonQueries.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import Foundation

struct PokemonQueries {
    static let pokemonBaseQuery = """
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
                id
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
    
    static let pokemonTypesQuery = """
        query samplePokeAPIquery {
          type{
              id
              name
              TypeefficaciesByTargetTypeId(where: {damage_factor: {_neq: 100}}) {
                  damage_factor
                  type {
                      id
                      name
                  }
              }
          }
        }
        """
    
    static let pokemonGenerationsQuery = """
        query getGenerations {
          generation {
            name
          }
        }
        """
}
