//
//  HomeView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel
    private let authViewModel: AuthViewModel
    private let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel
    private let makeSelectListViewModel: (Int, String) -> SelectListViewModel

    init(
        viewModel: HomeViewModel,
        authViewModel: AuthViewModel,
        makeMovieDetailsViewModel: @escaping (Int) -> MovieDetailsViewModel,
        makeSelectListViewModel: @escaping (Int, String) -> SelectListViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.authViewModel = authViewModel
        self.makeMovieDetailsViewModel = makeMovieDetailsViewModel
        self.makeSelectListViewModel = makeSelectListViewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(MovieSection.allCases) { section in
                        MovieSectionView(
                            section: section,
                            state: viewModel.state(for: section),
                            onRetry: {
                                Task {
                                    await viewModel.loadMovies(for: section)
                                }
                            }
                        )
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.loadMovies()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MovieCardItemViewModel.self) { item in
                MovieDetailsView(
                    viewModel: makeMovieDetailsViewModel(item.id),
                    authViewModel: authViewModel,
                    makeSelectListViewModel: makeSelectListViewModel
                )
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}
