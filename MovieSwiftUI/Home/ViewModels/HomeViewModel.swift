//
//  HomeViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    enum SectionState {
        case loading
        case loaded([MovieCardItemViewModel])
        case failed(String)

        var isLoaded: Bool {
            if case .loaded = self { return true }
            return false
        }
    }

    private let fetchMoviesUseCase: any FetchMoviesUseCase

    private(set) var sectionStates: [MovieSection: SectionState] = [:]

    init(fetchMoviesUseCase: any FetchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }

    func state(for section: MovieSection) -> SectionState {
        sectionStates[section] ?? .loading
    }

    func loadMovies() async {
        await withTaskGroup(of: Void.self) { group in
            for section in MovieSection.allCases {
                group.addTask {
                    await self.loadMovies(for: section)
                }
            }
        }
    }

    func loadMovies(for section: MovieSection) async {
        if !state(for: section).isLoaded {
            sectionStates[section] = .loading
        }

        do {
            let moviesPage = try await fetchMoviesUseCase.execute(
                section: section,
                category: .movies,
                page: 1
            )
            sectionStates[section] = .loaded(
                moviesPage.movies.map(MovieCardItemViewModel.init(movie:))
            )
        } catch {
            handle(error: error, for: section)
        }
    }

    private func handle(error: Error, for section: MovieSection) {
        guard !error.isCancellation else { return }
        sectionStates[section] = .failed(
            error.isInternetConnectionError
                ? "No internet connection"
                : "Failed loading movies"
        )
    }
}
