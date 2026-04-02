//
//  TypeEfficacy.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//


import Foundation

struct TypeEfficacy: Codable, Hashable {
    let damage_factor: Int
    let type: AttackerType
}