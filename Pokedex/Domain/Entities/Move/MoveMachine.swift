//
//  MoveMachine.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct MoveMachine: Codable, Hashable {
    let item: MoveMachineItem
}

struct MoveMachineItem: Codable, Hashable {
    let name: String
}
