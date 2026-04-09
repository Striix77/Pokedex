//
//  ErrorHandler.swift
//  Pokedex
//
//  Created by Freak on 09.04.2026.
//
import SwiftUI

struct ErrorHandler {
    static func handleFetching(_ function: () async throws ->  Void) async -> String?{
        var errorMessage: String? = nil
        do{
            try await function()
        } catch {
            errorMessage = error.localizedDescription
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, _):
                    print("❌ Missing Key: \(key.stringValue)")
                case .typeMismatch(let type, let context):
                    print("❌ Type Mismatch: \(type) at \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("❌ Value Not Found: \(type) at \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("❌ Data Corrupted at \(context.codingPath)")
                @unknown default:
                    print("❌ Unknown Decoding Error")
                }
            } else {
                print("❌ Other error: \(error.localizedDescription)")
            }
        }
        return errorMessage
    }
}
