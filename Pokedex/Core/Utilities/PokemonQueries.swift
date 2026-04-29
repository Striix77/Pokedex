//
//  PokemonQueries.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//
import Foundation

struct PokemonQueries {
    static let pokemonListQuery = """
            query getPokemonList {
              pokemon {
                id
                name
                pokemonsprites {
                    sprites
                  }
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
              }
            }
            """
    
    static func getPokemonDetailsQuery(for id: Int) -> String {
            """
            query getPokemonDetails {
                pokemon(where: {id: {_eq: \(id)}}) {
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
              
                  pokemoncries {
                      cries
                  }
                }
            }
            """
        }
    
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
