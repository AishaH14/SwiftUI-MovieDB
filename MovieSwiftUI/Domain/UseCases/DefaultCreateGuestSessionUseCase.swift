//
//  DefaultCreateGuestSessionUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

final class DefaultCreateGuestSessionUseCase: CreateGuestSessionUseCase {

    private let authRepository: any AuthRepository

    init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async throws -> String {
        return try await authRepository.createGuestSession()
    }
}
