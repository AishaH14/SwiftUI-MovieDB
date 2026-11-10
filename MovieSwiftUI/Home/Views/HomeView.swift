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
    private let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel

    init(
        viewModel: HomeViewModel,
        makeMovieDetailsViewModel: @escaping (Int) -> MovieDetailsViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.makeMovieDetailsViewModel = makeMovieDetailsViewModel
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
            .navigationDestination(for: MovieSummary.self) { movie in
                MovieDetailsView(
                    viewModel: makeMovieDetailsViewModel(movie.id)
                )
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}
