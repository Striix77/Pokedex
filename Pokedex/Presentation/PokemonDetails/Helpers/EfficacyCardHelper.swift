//
//  EfficacyCardHelper.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

struct EfficacyCardHelper {

    static func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                PokedexStrings.getIconURLString(for: id)
        )
    }
}
