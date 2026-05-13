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
    var confirmAction: () -> Void
    let errorMessage: String?
    
    private let alertLabel = "Error"
    private let retryLabel = "Retry"
    private let okLabel = "Ok"
    private let fallbackErrorMessage = "Ok"
    
    func body(content: Content) -> some View {
        content
            .alert(alertLabel, isPresented: $showAlert) {
                Button(role: .confirm) {
                    Task {
                        await fetchAction()
                    }
                } label: {
                    Text(retryLabel)
                }
                Button(role: .cancel) {
                    confirmAction()
                } label: {
                    Text(okLabel)
                }
            } message: {
                Text(
                    errorMessage
                        ?? fallbackErrorMessage
                )
            }
    }
}
