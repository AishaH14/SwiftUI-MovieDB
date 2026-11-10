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
        case loaded([MovieSummary])
        case failed(String)
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
        if case .loaded = state(for: section) {
        } else {
            sectionStates[section] = .loading
        }

        do {
            let moviesPage = try await fetchMoviesUseCase.execute(
                section: section,
                page: 1
            )
            sectionStates[section] = .loaded(moviesPage.movies)
        } catch is CancellationError {
            // Cancelled: expected, no error shown
        } catch let error as URLError where error.code == .cancelled {
            // Cancelled: expected, no error shown
        } catch {
            sectionStates[section] = .failed(error.localizedDescription)
        }
    }
}
