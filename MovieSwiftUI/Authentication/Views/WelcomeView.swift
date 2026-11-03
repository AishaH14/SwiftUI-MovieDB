
//
//  WelcomeView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//

import SwiftUI
import AuthenticationServices

struct WelcomeView: View {

    let authViewModel: AuthViewModel

    @Environment(\.webAuthenticationSession)
    private var webAuthenticationSession

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image("MovieLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())

                Text("Welcome to MovieDB")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("Discover movies, create lists, and save your favorites.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                VStack(spacing: 14) {

                    // MARK: - Guest

                    Button {
                        Task { await authViewModel.continueAsGuest() }
                    } label: {
                        if authViewModel.loadingAction == .guest {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Continue as Guest")
                        }
                    }
                    .buttonStyle(AuthButtonStyle(kind: .primary))
                    .disabled(authViewModel.isLoading)

                    // MARK: - TMDB Sign In

                    Button {
                        Task { await authViewModel.signIn(using: authenticate) }
                    } label: {
                        HStack(spacing: 10) {
                            if authViewModel.loadingAction == .signIn {
                                ProgressView()
                                    .tint(.white)
                                Text("Signing In...")
                            } else {
                                Text("Sign In")
                            }
                        }
                    }
                    .buttonStyle(AuthButtonStyle(kind: .secondary))
                    .disabled(authViewModel.isLoading)

                    // MARK: - Error Message

                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            }
        }
    }

    // MARK: - Web Authentication

    private func authenticate(url: URL, scheme: String) async throws -> URL {
        do {
            return try await webAuthenticationSession.authenticate(
                using: url,
                callbackURLScheme: scheme
            )
        } catch let error as ASWebAuthenticationSessionError
                    where error.code == .canceledLogin {
            throw CancellationError()
        }
    }
}

// MARK: - Preview

private struct PreviewGuestSessionUseCase: CreateGuestSessionUseCase {
    func execute() async throws -> String {
        "preview-guest-session"
    }
}

private struct PreviewRequestTokenUseCase: CreateRequestTokenUseCase {
    func execute() async throws -> String {
        "preview-request-token"
    }
}

private struct PreviewCreateSessionUseCase: CreateSessionUseCase {
    func execute(requestToken: String) async throws -> String {
        "preview-user-session"
    }
}

#Preview {
    WelcomeView(
        authViewModel: AuthViewModel(
            createGuestSessionUseCase: PreviewGuestSessionUseCase(),
            createRequestTokenUseCase: PreviewRequestTokenUseCase(),
            createSessionUseCase: PreviewCreateSessionUseCase()
        )
    )
}
