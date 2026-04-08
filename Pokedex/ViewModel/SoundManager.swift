//
//  SoundManager.swift
//  Pokedex
//
//  Created by Freak on 03.04.2026.
//
import SwiftUI
import AVFoundation

class SoundManager {
    let audioPlayer = AVPlayer()
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func playCry(name: String) {
        let urlString = PokedexStrings.getPokemonCryURLString(
            for: name.lowercased()
        )

        guard let url = URL(string: urlString) else { return }

        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
    }

    func canPlaySound(of name: String) async -> Bool {
        let urlString = PokedexStrings.getPokemonCryURLString(
            for: name.lowercased()
        )

        guard let url = URL(string: urlString) else { return false }
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
