//
//  DefaultCreateSessionUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

final class DefaultCreateSessionUseCase: CreateSessionUseCase {

    private let authRepository: any AuthRepository

    init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(requestToken: String) async throws -> String {
        try await authRepository.createSession(
            requestToken: requestToken
        )
    }
}
