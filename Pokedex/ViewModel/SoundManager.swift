import AVFoundation
//
//  SoundManager.swift
//  Pokedex
//
//  Created by Freak on 03.04.2026.
//
import SwiftUI

@Observable
class SoundManager {
    var audioPlayer: AVPlayer?

    func playCry(name: String) {
        let urlString =
            "https://play.pokemonshowdown.com/audio/cries/\(name.lowercased()).mp3"

        guard let url = URL(string: urlString) else { return }

        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }

    func canPlaySound(of name: String)async -> Bool {
        let urlString =
            "https://play.pokemonshowdown.com/audio/cries/\(name.lowercased()).mp3"
        
        guard let url = URL(string:urlString) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0

        do {
                let (_, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    return httpResponse.statusCode == 200
                }
            } catch {
                return false
            }
            
            return false
    }
}
