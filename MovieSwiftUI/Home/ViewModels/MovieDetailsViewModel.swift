//
//  MovieDetailsViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailsViewModel {

    enum State {
        case loading
        case loaded(MovieSummary)
        case failed(String)
    }

    let movieId: Int
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase

    private(set) var state: State = .loading

    init(
        movieId: Int,
        fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    ) {
        self.movieId = movieId
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    }

    func loadDetails() async {
        state = .loading

        do {
            let movie = try await fetchMovieDetailsUseCase.execute(
                movieId: movieId
            )
            state = .loaded(movie)
        } catch {
            handle(error: error)
        }
    }

    private func handle(error: Error) {
        guard !error.isCancellation else { return }
        state = .failed(
            error.isInternetConnectionError
                ? "No internet connection"
                : "Failed loading movie details"
        )
    }
    }
