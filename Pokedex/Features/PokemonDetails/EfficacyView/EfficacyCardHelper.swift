//
//  EfficacyCardHelper.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import SwiftUI

struct EfficacyCardHelper{
    
    
    static func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                PokedexStrings.getIconURLString(for: id)
        )
    }
    
    static func getBackgroundColor(for efficacy: TypeStrength, colorScheme: ColorScheme) -> Color{
        TypeColor(rawValue: efficacy.name.lowercased())?.color.opacity(
            colorScheme == .light ? 0.5 : 0.3
        )
            ?? .gray
    }
}
