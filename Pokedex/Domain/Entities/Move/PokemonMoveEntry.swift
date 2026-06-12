//
//  PokemonMoveEntry.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct PokemonMoveEntry: Codable, Hashable {
    let id: Int
    let level: Int
    let movelearnmethod: MoveLearnMethod
    let move: MoveEntry
    let versiongroup: PokemonGameVersion

    var levelString: String {
        "Lv \(level)"
    }

    var moveLearnType: MoveLearnType {
        if let badge = move.machineBadge {
            return MoveLearnType(
                rawValue: badge.hasPrefix("TM") ? "tm" : "hm"

            ) ?? .levelUp
        }
        else {
            if level > 0 {
                return .levelUp
            }
            else {
                return .egg
            }
        }
    }
}
