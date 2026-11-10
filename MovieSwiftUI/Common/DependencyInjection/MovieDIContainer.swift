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

    init(networkClient: any NetworkClient) {
        self.movieRepository = DefaultMovieRepository(
            networkClient: networkClient
        )
    }

    // MARK: - Use Cases

    func makeFetchMoviesUseCase() -> any FetchMoviesUseCase {
        DefaultFetchMoviesUseCase(
            movieRepository: movieRepository
        )
    }
    
    // MARK: - ViewModels

    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchMoviesUseCase: makeFetchMoviesUseCase()
        )
    }
    
    func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository
        )
    }

    @MainActor
    func makeMovieDetailsViewModel(movieId: Int) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            movieId: movieId,
            fetchMovieDetailsUseCase: makeFetchMovieDetailsUseCase()
        )
    }
}
