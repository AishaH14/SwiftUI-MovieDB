//
//  MovieDIContainer.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class MovieDIContainer {

    private let movieRepository: any MovieRepository
    private let accountRepository: any AccountRepository

    init(
        networkClient: any NetworkClient,
        accountRepository: any AccountRepository
    ) {
        self.movieRepository = DefaultMovieRepository(
            networkClient: networkClient
        )
        self.accountRepository = accountRepository
    }

    // MARK: - Use Cases

    func makeFetchMoviesUseCase() -> any FetchMoviesUseCase {
        DefaultFetchMoviesUseCase(
            movieRepository: movieRepository
        )
    }

    func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository
        )
    }

    func makeMovieUserStateUseCase() -> any MovieUserStateUseCase {
        DefaultMovieUserStateUseCase(
            accountRepository: accountRepository
        )
    }

    // MARK: - ViewModels

    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchMoviesUseCase: makeFetchMoviesUseCase()
        )
    }

    @MainActor
    func makeMovieDetailsViewModel(movieId: Int) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            movieId: movieId,
            fetchMovieDetailsUseCase: makeFetchMovieDetailsUseCase(),
            movieUserStateUseCase: makeMovieUserStateUseCase()
        )
    }
}
