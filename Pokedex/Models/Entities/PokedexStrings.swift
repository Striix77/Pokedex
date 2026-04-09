//
//  PokedexStrings.swift
//  Pokedex
//
//  Created by Freak on 08.04.2026.
//
import Foundation

struct PokedexStrings{
    static let apiURL = "https://graphql.pokeapi.co/v1beta2"
    
    
    
    static func getIconURLString(for id: Int) -> String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-ix/scarlet-violet/small/\(id).png"
    }
    
    static func getPokemonCryURLString(for name: String) -> String{
        "https://play.pokemonshowdown.com/audio/cries/\(name).mp3"
    }
    
}
