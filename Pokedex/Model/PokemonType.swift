//
//  PokemonType.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//
import Foundation

struct PokemonType: Codable, Hashable {
    let id: Int
    let name: String
    let typeEfficaciesByTargetTypeId: [TypeEfficacy]?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case typeEfficaciesByTargetTypeId = "TypeefficaciesByTargetTypeId"
    }
}

