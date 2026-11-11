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
    private let listRepository: any ListRepository

    init(networkClient: any NetworkClient) {
        self.accountRepository = DefaultAccountRepository(
            networkClient: networkClient
        )
        self.listRepository = DefaultListRepository(
            networkClient: networkClient
        )
    }

    // MARK: - Use Cases

    func makeFetchAccountUseCase() -> any FetchAccountUseCase {
        DefaultFetchAccountUseCase(
            accountRepository: accountRepository
        )
    }

    func makeFetchListsUseCase() -> any FetchListsUseCase {
        DefaultFetchListsUseCase(
            accountRepository: accountRepository,
            listRepository: listRepository
        )
    }

    func makeCreateListUseCase() -> any CreateListUseCase {
        DefaultCreateListUseCase(
            listRepository: listRepository
        )
    }

    func makeDeleteListUseCase() -> any DeleteListUseCase {
        DefaultDeleteListUseCase(
            listRepository: listRepository
        )
    }

    // MARK: - ViewModels

    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchAccountUseCase: makeFetchAccountUseCase()
        )
    }

    @MainActor
    func makeListsViewModel(sessionId: String) -> ListsViewModel {
        ListsViewModel(
            sessionId: sessionId,
            fetchListsUseCase: makeFetchListsUseCase(),
            deleteListUseCase: makeDeleteListUseCase(),
            makeCreateListViewModel: { [unowned self] in
                self.makeCreateListViewModel(sessionId: sessionId)
            }
        )
    }

    @MainActor
    func makeCreateListViewModel(sessionId: String) -> CreateListViewModel {
        CreateListViewModel(
            sessionId: sessionId,
            createListUseCase: makeCreateListUseCase()
        )
    }
}
