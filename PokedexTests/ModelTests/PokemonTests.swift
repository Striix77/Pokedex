//
//  PokemonTests.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import Testing

@testable import Pokedex

@Suite("Pokemon Model Tests")
struct PokemonTests {

    @Test("Stat helper retrieves the correct value")
    func statValueHelper() {
        // Arrange
        let pika = Pokemon.mock(id: 25, name: "Pikachu")

        // Act
        let hp = pika.statValue(named: "hp")

        // Assert
        #expect(hp == 49)
    }

    @Test("Stat helper returns 0 for missing stats")
    func missingStatHelper() {
        let pika = Pokemon.mock(id: 25, name: "Pikachu")

        #expect(pika.statValue(named: "speed") == 0)
    }
}
