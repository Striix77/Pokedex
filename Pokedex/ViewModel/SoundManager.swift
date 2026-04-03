//
//  SoundManager.swift
//  Pokedex
//
//  Created by Freak on 03.04.2026.
//
import SwiftUI
import AVFoundation

@Observable
class SoundManager {
    var audioPlayer: AVPlayer?

    func playCry(name: String) {
        let urlString = "https://play.pokemonshowdown.com/audio/cries/\(name.lowercased()).mp3"
        
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }
}
