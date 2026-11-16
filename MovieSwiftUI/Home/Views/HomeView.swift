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

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
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
        .task {
            await viewModel.loadMovies()
        }
    }
}
