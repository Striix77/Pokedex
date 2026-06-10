//
//  MoveEffect.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct MoveEffect: Codable, Hashable {
    let moveeffecteffecttexts: [MoveEffectText]

    var shortEffect: String? {
        moveeffecteffecttexts.first?.short_effect
    }
}
