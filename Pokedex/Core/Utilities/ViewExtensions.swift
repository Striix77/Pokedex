//
//  ViewExtensions.swift
//  Pokedex
//
//  Created by Freak on 08.05.2026.
//
import SwiftUI

extension View {
    func fetchingAlert(
        showAlert: Binding<Bool>,
        fetchAction: @escaping () async -> Void,
        confirmAction: @escaping () -> Void,
        errorMessage: String?
    ) -> some View {
        modifier(
            FailedFetchingAlert(
                showAlert: showAlert,
                fetchAction: fetchAction,
                confirmAction: confirmAction,
                errorMessage: errorMessage
            )
        )
    }
}
