//
//  MoveEntry.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct MoveEntry: Codable, Hashable {
    let name: String
    let power: Int?
    let accuracy: Int?
    let pp: Int?
    let type: MoveType
    let movedamageclass: MoveDamageClass
    let moveeffect: MoveEffect?
    let machines: [MoveMachine]?

    var formattedName: String {
        name.split(separator: "-").map { $0.capitalized }.joined(separator: " ")
    }

    /// e.g. "tm01" → "TM01", "hm03" → "HM03", nil for non-machine moves
    var machineBadge: String? {
        guard let itemName = machines?.first?.item.name else { return nil }
        return itemName.uppercased()
    }
}
