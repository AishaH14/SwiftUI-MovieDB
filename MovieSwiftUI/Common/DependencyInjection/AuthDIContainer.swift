//
//  AuthDIContainer.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation


final class AuthDIContainer {

    private let authRepository: any AuthRepository

    init(networkClient: any NetworkClient) {
        self.authRepository = DefaultAuthRepository(
            networkClient: networkClient
        )
    }

    // MARK: - Use Cases

    func makeGuestSessionUseCase() -> any CreateGuestSessionUseCase {
        DefaultCreateGuestSessionUseCase(
            authRepository: authRepository
        )
    }

    func makeRequestTokenUseCase() -> any CreateRequestTokenUseCase {
        DefaultCreateRequestTokenUseCase(
            authRepository: authRepository
        )
    }

    func makeCreateSessionUseCase() -> any CreateSessionUseCase {
        DefaultCreateSessionUseCase(
            authRepository: authRepository
        )
    }

    // MARK: - ViewModels

    @MainActor
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            createGuestSessionUseCase: makeGuestSessionUseCase(),
            createRequestTokenUseCase: makeRequestTokenUseCase(),
            createSessionUseCase: makeCreateSessionUseCase()
        )
    }
}
