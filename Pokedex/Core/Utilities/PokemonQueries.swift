//
//  PokemonQueries.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//
import Foundation

enum PokemonQueries {
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
        pokemonspecy {
              pokemonspeciesnames(where: {language_id: {_eq: 9}}) {
                genus
              }
              pokemonspeciesflavortexts(
                where: {language_id: {_eq: 9}}
                order_by: {version_id: asc}
                limit: 1
              ) {
                flavor_text
              }
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
    
    static func getQueryForVersionGroups(for pokemonName: String) -> String {
        """
        query GetVersionGroupsForPokemon {
          versiongroup(
            where: {
              pokemonmoves: {
                pokemon: { name: { _eq: "\(pokemonName.lowercased())" } }
              }
            }
            order_by: { id: asc }
          ) {
            id
            name
            generation {
              name
            }
          }
        }
        """
    }

    static func getMovesQuery(for pokemonName: String, versionGroupName: String) -> String {
        """
        query PokemonMovesByVersion {
          pokemon(where: {name: {_eq: "\(pokemonName)"}}) {
            pokemonmoves(
              where: {versiongroup: {name: {_eq: "\(versionGroupName)"}}}
              order_by: [{move_learn_method_id: asc}, {level: asc}]
            ) {
              id
              level
              movelearnmethod {
                name
              }
              move {
                name
                power
                accuracy
                pp
                type {
                  id
                  name
                }
                movedamageclass {
                  name
                }
                moveeffect {
                  moveeffecteffecttexts(where: {language_id: {_eq: 9}}) {
                    short_effect
                  }
                }
                machines(where: {versiongroup: {name: {_eq: "\(versionGroupName)"}}}) {
                  item {
                    name
                  }
                }
              }
              versiongroup{
                id
                name
                generation {
                  name
                }
              }
            }
          }
        }
        """
    }
}
