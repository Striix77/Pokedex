//
//  TypeColor.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//
import SwiftUI

enum TypeColor: String {
    case fire, water, grass, electric, ice, fighting, poison, ground, flying,
        psychic, bug, rock, ghost, dragon, dark, steel, fairy, normal, stellar,
        unknown, shadow

    var color: Color {
        switch self {
        case .bug: return Color.bug
        case .dark: return Color.dark
        case .dragon: return Color.dragon
        case .electric: return Color.electric
        case .fairy: return Color.fairy
        case .fighting: return Color.fighting
        case .fire: return Color.fire
        case .flying: return Color.flying
        case .ghost: return Color.ghost
        case .grass: return Color.grass
        case .ground: return Color.ground
        case .ice: return Color.ice
        case .normal: return Color.normal
        case .poison: return Color.poison
        case .psychic: return Color.psychic
        case .rock: return Color.rock
        case .steel: return Color.steel
        case .water: return Color.water
        default: return Color.unknown
        }
    }

    static func getDoubleTypeColors(for pokemon: Pokemon) -> (Color?, Color?) {
        let types = pokemon.pokemontypes
        guard !types.isEmpty else {
            return (nil, nil)
        }

        var colors: (Color?, Color?) {
            let firstTypeColor = TypeColor(
                rawValue: types[0].type.name
            )?.color
            guard types.count > 1 else {
                return (firstTypeColor, nil)
            }
            let secondTypeColor = TypeColor(
                rawValue: types[1].type.name
            )?.color
            return (firstTypeColor, secondTypeColor)
        }
        return colors
    }

}
