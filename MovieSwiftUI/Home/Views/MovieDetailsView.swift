//
//  MovieDetailsView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {

    @State private var viewModel: MovieDetailsViewModel
    @State private var isShowingSelectList = false
    @State private var isShowingSignIn = false
    private let authViewModel: AuthViewModel
    private let makeSelectListViewModel: (Int, String) -> SelectListViewModel

    init(
        viewModel: MovieDetailsViewModel,
        authViewModel: AuthViewModel,
        makeSelectListViewModel: @escaping (Int, String) -> SelectListViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.authViewModel = authViewModel
        self.makeSelectListViewModel = makeSelectListViewModel
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingSelectList) {
                if let sessionId = authViewModel.sessionId {
                    SelectListView(
                        viewModel: makeSelectListViewModel(viewModel.movieId, sessionId)
                    )
                }
            }
            .navigationDestination(isPresented: $isShowingSignIn) {
                SignInPromptView(
                    authViewModel: authViewModel,
                    navigationTitle: "My Lists",
                    title: "Sign in to use My Lists",
                    message: "Sign in to TMDB to add movies to your lists."
                )
            }
            .task {
                await viewModel.loadDetails()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()

        case .loaded(let movie):
            details(for: movie)
                .navigationTitle(movie.title)

        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    Task {
                        await viewModel.loadDetails()
                    }
                }
            }
            .padding()
        }
    }

    private func details(for movie: MovieSummary) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                backdrop(for: movie)

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.orange)

                        Text(movie.rating, format: .number.precision(.fractionLength(1)))
                    }

                    actionButtons

                    Text(movie.overview)
                }
                .padding(.horizontal)
            }
        }
    }

    private func backdrop(for movie: MovieSummary) -> some View {
        AsyncImage(url: backdropURL(for: movie)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "film")
                    .foregroundStyle(.secondary)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .background(Color.gray.opacity(0.2))
        .clipped()
    }

    private var actionButtons: some View {
        HStack {
            MovieActionButton(title: "Add Watchlist", systemImage: "bookmark")
            MovieActionButton(title: "Add Favorite", systemImage: "heart")

            Button {
                if authViewModel.isSignedIn {
                    isShowingSelectList = true
                } else {
                    isShowingSignIn = true
                }
            } label: {
                MovieActionLabel(title: "Add to List", systemImage: "text.badge.plus")
            }
            .foregroundStyle(Color.gray)
        }
    }

    private func backdropURL(for movie: MovieSummary) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")
    }
}

// MARK: - Action Button

private struct MovieActionButton: View {

    let title: String
    let systemImage: String

    @State private var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            MovieActionLabel(
                title: title,
                systemImage: isSelected ? "checkmark" : systemImage
            )
        }
        .foregroundStyle(isSelected ? Color.green : Color.gray)
    }
}

private struct MovieActionLabel: View {

    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title3)

            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}
