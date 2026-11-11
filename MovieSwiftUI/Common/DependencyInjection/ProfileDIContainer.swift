//
//  ProfileDIContainer.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation

final class ProfileDIContainer {

    private let accountRepository: any AccountRepository

    init(networkClient: any NetworkClient) {
        self.accountRepository = DefaultAccountRepository(
            networkClient: networkClient
        )
    }

    // MARK: - Use Cases

    func makeFetchAccountUseCase() -> any FetchAccountUseCase {
        DefaultFetchAccountUseCase(
            accountRepository: accountRepository
        )
    }

    // MARK: - ViewModels

    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchAccountUseCase: makeFetchAccountUseCase()
        )
    }
}
