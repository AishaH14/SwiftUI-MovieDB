//
//  DefaultCreateRequestTokenUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

final class DefaultCreateRequestTokenUseCase: CreateRequestTokenUseCase {

    private let authRepository: any AuthRepository

    init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async throws -> String {
        try await authRepository.createRequestToken()
    }
}
