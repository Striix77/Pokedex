//
//  SpriteData.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

struct SpriteData: Codable, Hashable {
    let other: OtherSprites?
}

struct OtherSprites: Codable, Hashable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        // We must map this because JSON uses a hyphen, but Swift variables can't
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable, Hashable {
    let front_default: String?
}
