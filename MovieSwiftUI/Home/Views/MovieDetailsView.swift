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
    @Environment(Router.self) private var router
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
            .alert("Error", isPresented: isShowingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task {
                await viewModel.loadDetails()
            }
            .task(id: authViewModel.sessionId) {
                guard let sessionId = authViewModel.sessionId else { return }
                await viewModel.loadUserState(sessionId: sessionId)
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

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack {
            MovieActionButton(
                title: viewModel.isInWatchlist ? "Added Watchlist" : "Add Watchlist",
                systemImage: viewModel.isInWatchlist ? "checkmark" : "bookmark",
                color: viewModel.isInWatchlist ? .green : .gray
            ) {
                performIfSignedIn { sessionId in
                    await viewModel.toggleWatchlist(sessionId: sessionId)
                }
            }
            .disabled(viewModel.isUpdatingWatchlist)

            MovieActionButton(
                title: viewModel.isFavorite ? "Added Favorite" : "Add Favorite",
                systemImage: viewModel.isFavorite ? "heart.fill" : "heart",
                color: .red
            ) {
                performIfSignedIn { sessionId in
                    await viewModel.toggleFavorite(sessionId: sessionId)
                }
            }
            .disabled(viewModel.isUpdatingFavorite)

            MovieActionButton(
                title: "Add to List",
                systemImage: "text.badge.plus",
                color: .gray
            ) {
                performIfSignedIn { _ in
                    isShowingSelectList = true
                }
            }
        }
    }
    
    private func performIfSignedIn(_ action: @escaping (String) async -> Void) {
        guard let sessionId = authViewModel.sessionId else {
            router.push(.signIn(.saveMovies))
            return
        }
        Task { await action(sessionId) }
    }

    private func backdropURL(for movie: MovieSummary) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")
    }

    // MARK: - Alerts

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

// MARK: - Action Button

private struct MovieActionButton: View {

    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title3)

                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(color)
    }
}
