//
//  SignInPromptView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct SignInPromptView: View {

    let authViewModel: AuthViewModel
    let navigationTitle: String
    let title: String
    let message: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession

    private var isSigningIn: Bool {
        authViewModel.loadingAction == .signIn
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "lock")
        } description: {
            Text(message)
        } actions: {
            VStack(spacing: 12) {
                Button {
                    Task { await authViewModel.signIn(using: authenticate) }
                } label: {
                    Group {
                        if isSigningIn {
                            ProgressView()
                        } else {
                            Text("Sign in with TMDB")
                        }
                    }
                    .frame(minWidth: 180)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isSigningIn)

                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .navigationTitle(navigationTitle)
        .onChange(of: authViewModel.isSignedIn) { _, isSignedIn in
            if isSignedIn { dismiss() }
        }
    }

    private func authenticate(url: URL, scheme: String) async throws -> URL {
        try await webAuthenticationSession.authenticateWithTMDB(
            url: url,
            callbackScheme: scheme
        )
    }
}
