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
        case .bug: return Color(red: 0.776, green: 0.82, blue: 0.549)  // #c6d18c
        case .dark: return Color(red: 0.655, green: 0.631, blue: 0.616)  // #a7a19d
        case .dragon: return Color(red: 0.616, green: 0.561, blue: 0.769)  // #9d8fc4
        case .electric: return Color(red: 0.996, green: 0.878, blue: 0.545)  // #fee08b
        case .fairy: return Color(red: 0.976, green: 0.769, blue: 0.976)  // #f9c4f9
        case .fighting: return Color(red: 0.988, green: 0.698, blue: 0.541)  // #fcb28a
        case .fire: return Color(red: 0.988, green: 0.62, blue: 0.612)  // #fc9e9c
        case .flying: return Color(red: 0.722, green: 0.831, blue: 0.988)  // #b8d4fc
        case .ghost: return Color(red: 0.627, green: 0.561, blue: 0.678)  // #a08fad
        case .grass: return Color(red: 0.663, green: 0.859, blue: 0.616)  // #a9db9d
        case .ground: return Color(red: 0.792, green: 0.706, blue: 0.604)  // #cab49a
        case .ice: return Color(red: 0.635, green: 0.976, blue: 0.988)  // #a2f9fc
        case .normal: return Color(red: 0.816, green: 0.816, blue: 0.816)  // #d0d0d0
        case .poison: return Color(red: 0.792, green: 0.69, blue: 0.851)  // #cab0d9
        case .psychic: return Color(red: 0.988, green: 0.722, blue: 0.847)  // #fcb8d8
        case .rock: return Color(red: 0.859, green: 0.827, blue: 0.737)  // #dbd3bc
        case .steel: return Color(red: 0.737, green: 0.776, blue: 0.812)  // #bcc6cf
        case .water: return Color(red: 0.682, green: 0.871, blue: 0.992)  // #aedefd
        default: return Color(red: 0.8784, green: 0.8784, blue: 0.8784)  // light gray
        }
    }

    static func getSafeColor(for typeName: String, scheme: ColorScheme) -> Color
    {
        let type = TypeColor(rawValue: typeName.lowercased()) ?? .normal

        return type.color.opacity(scheme == .light ? 0.5 : 0.3)
    }

    static func getDoubleTypeColors(for pokemon: Pokemon) -> (Color?, Color?) {

        var colors: (Color?, Color?)
        colors.0 =
            TypeColor(
                rawValue: pokemon.pokemontypes[0].type
                    .name
            )?.color
        if pokemon.pokemontypes.count > 1 {
            colors.1 =
                TypeColor(
                    rawValue: pokemon.pokemontypes[1]
                        .type.name
                )?.color
        }
        return colors
    }

}
