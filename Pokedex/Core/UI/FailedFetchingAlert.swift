//
//  FailedFetchingAlert.swift
//  Pokedex
//
//  Created by Freak on 08.05.2026.
//
import SwiftUI

struct FailedFetchingAlert: ViewModifier {
    @Binding var showAlert: Bool
    var fetchAction: () async -> Void
    let errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $showAlert) {
                Button(role: .confirm) {
                    Task {
                        await fetchAction()
                    }
                } label: {
                    Text("Retry")
                }
                Button(role: .cancel) {
                } label: {
                    Text("OK")
                }
            } message: {
                Text(
                    errorMessage
                        ?? "An unexpected error occured. Please try again later!"
                )
            }
    }
}
