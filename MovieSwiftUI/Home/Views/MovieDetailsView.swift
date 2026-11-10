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

    init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
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
            MovieActionButton(title: "Add to List", systemImage: "text.badge.plus")
        }
    }

    private func backdropURL(for movie: MovieSummary) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")
    }
}
private struct MovieActionButton: View {

    let title: String
    let systemImage: String

    @State private var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            VStack(spacing: 6) {
                Image(systemName: isSelected ? "checkmark" : systemImage)
                    .font(.title3)

                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(isSelected ? Color.green : Color.gray)
    }
}
