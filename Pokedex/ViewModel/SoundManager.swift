//
//  SoundManager.swift
//  Pokedex
//
//  Created by Freak on 03.04.2026.
//
import Foundation
import AVFoundation

@Observable
class SoundManager {
    let audioPlayer = AVPlayer()
    private var canPlayCache: [String:Bool] = [:]
    
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
    
    private func checkSoundExistence(of name: String) async -> Bool{
        let urlString = PokedexStrings.getPokemonCryURLString(
            for: name.lowercased()
        )
        guard let url = URL(string: urlString) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0
        
        let response = try? await URLSession.shared.data(for: request).1
        return (response as? HTTPURLResponse)?.statusCode == 200

    }

    func canPlaySound(of name: String) async -> Bool {
        if let cachedResult = canPlayCache[name] {
            return cachedResult
        }
        
        let result = await checkSoundExistence(of: name)
        
        canPlayCache[name] = result
        return result
    }
}
