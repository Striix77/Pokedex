//
//  TypeEfficacy.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import Foundation

struct TypeEfficacy: Codable, Hashable {
    let damageFactor: Int
    let type: AttackerType
    
    enum CodingKeys: String, CodingKey {
        case damageFactor = "damage_factor"
        case type = "type"
    }
}
