//
//  StatEntry.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//
import Foundation

struct StatEntry: Codable, Hashable {
    let base_stat: Int
    let stat: StatDetails
}
