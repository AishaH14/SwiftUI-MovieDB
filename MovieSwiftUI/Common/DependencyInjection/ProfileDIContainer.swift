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
    
    init(
        networkClient: any NetworkClient,
        accountRepository: any AccountRepository
    ) {
        self.accountRepository = accountRepository
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

    func makeFetchListDetailsUseCase() -> any FetchListDetailsUseCase {
        DefaultFetchListDetailsUseCase(
            listRepository: listRepository
        )
    }

    func makeListMoviesUseCase() -> any ListMoviesUseCase {
        DefaultListMoviesUseCase(
            listRepository: listRepository
        )
    }

    func makeMovieUserStateUseCase() -> any MovieUserStateUseCase {
        DefaultMovieUserStateUseCase(
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

    @MainActor
    func makeListsViewModel(sessionId: String) -> ListsViewModel {
        ListsViewModel(
            sessionId: sessionId,
            fetchListsUseCase: makeFetchListsUseCase(),
            deleteListUseCase: makeDeleteListUseCase(),
            makeCreateListViewModel: { [unowned self] in
                self.makeCreateListViewModel(sessionId: sessionId)
            },
            makeMediaListViewModel: { [unowned self] list in
                self.makeMediaListViewModel(source: .list(list), sessionId: sessionId)
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

    @MainActor
    func makeMediaListViewModel(source: MediaListSource, sessionId: String) -> MediaListViewModel {
        MediaListViewModel(
            source: source,
            sessionId: sessionId,
            fetchListDetailsUseCase: makeFetchListDetailsUseCase(),
            listMoviesUseCase: makeListMoviesUseCase(),
            movieUserStateUseCase: makeMovieUserStateUseCase()
        )
    }

    @MainActor
    func makeSelectListViewModel(movieId: Int, sessionId: String) -> SelectListViewModel {
        SelectListViewModel(
            movieId: movieId,
            sessionId: sessionId,
            fetchListsUseCase: makeFetchListsUseCase(),
            listMoviesUseCase: makeListMoviesUseCase()
        )
    }
}
