//
//  FlavorTextEntry.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import Foundation

struct FlavorTextEntry: Codable, Hashable {
    let flavor_text: String

    var cleanedText: String {
        flavor_text
            .replacingOccurrences(of: "\u{000C}", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
    }
}
