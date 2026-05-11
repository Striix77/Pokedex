//
//  OtherSprites.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

struct OtherSprites: Codable, Hashable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        // We must map this because JSON uses a hyphen, but Swift variables can't
        case officialArtwork = "official-artwork"
    }
}
