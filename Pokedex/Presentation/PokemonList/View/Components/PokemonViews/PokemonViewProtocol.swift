//
//  PokemonViewProtocol.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//
import SwiftUI

protocol PokemonViewProtocol: View {
    var allPokemon: [PokemonListEntry] {
        get
    }
}
