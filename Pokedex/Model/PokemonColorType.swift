//
//  PokemonColorType.swift
//  Pokedex
//
//  Created by Freak on 23.03.2026.
//

import SwiftUI

enum PokemonColorType: String, CaseIterable {
    case normal, fire, water, electric, grass, ice
    case fighting, poison, ground, flying, psychic, bug
    case rock, ghost, dragon, dark, steel, fairy
    
    var color: Color {
            switch self {
            case .normal: return Color(red: 0.75, green: 0.75, blue: 0.68)   // Soft grayish tan
                    case .fire: return Color(red: 0.96, green: 0.61, blue: 0.51)     // Warm pastel coral/orange
                    case .water: return Color(red: 0.54, green: 0.76, blue: 0.95)    // Soft sky blue
                    case .electric: return Color(red: 0.98, green: 0.85, blue: 0.38) // Butter yellow
                    case .grass: return Color(red: 0.56, green: 0.80, blue: 0.58)    // Muted minty green
                    case .ice: return Color(red: 0.65, green: 0.90, blue: 0.96)      // Frosty cyan
                    case .fighting: return Color(red: 0.82, green: 0.39, blue: 0.33) // Muted brick red
                    case .poison: return Color(red: 0.73, green: 0.53, blue: 0.72)   // Dusty violet
                    case .ground: return Color(red: 0.90, green: 0.79, blue: 0.55)   // Sandy beige
                    case .flying: return Color(red: 0.75, green: 0.81, blue: 0.96)   // Pale lavender-blue
                    case .psychic: return Color(red: 0.98, green: 0.65, blue: 0.76)  // Soft bubblegum pink
                    case .bug: return Color(red: 0.73, green: 0.82, blue: 0.45)      // Soft yellow-green
                    case .rock: return Color(red: 0.78, green: 0.73, blue: 0.54)     // Warm grayish-brown
                    case .ghost: return Color(red: 0.58, green: 0.53, blue: 0.74)    // Deep pastel purple
                    case .dragon: return Color(red: 0.54, green: 0.50, blue: 0.97)   // Soft indigo
                    case .dark: return Color(red: 0.56, green: 0.48, blue: 0.43)     // Muted dark cocoa
                    case .steel: return Color(red: 0.76, green: 0.76, blue: 0.85)    // Soft bluish-silver
                    case .fairy: return Color(red: 0.94, green: 0.70, blue: 0.85)    // Light cotton candy pink
            }
        }
}
