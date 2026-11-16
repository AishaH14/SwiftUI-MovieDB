//
//  MoviesListView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MoviesListView: View {

    @State private var viewModel: MoviesListViewModel

    init(viewModel: MoviesListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        searchableContent
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: isShowingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task {
                await viewModel.load()
            }
    }

    // MARK: - Search

    @ViewBuilder
    private var searchableContent: some View {
        if viewModel.isSearchable {
            screen
                .searchable(text: $viewModel.query, prompt: "Search movies, TV shows...")
                .searchSuggestions {
                    if viewModel.query.isEmpty {
                        ForEach(viewModel.recentQueries, id: \.self) { recentQuery in
                            Label(recentQuery, systemImage: "clock.arrow.circlepath")
                                .searchCompletion(recentQuery)
                        }
                    }
                }
                .onSubmit(of: .search) {
                    Task { await viewModel.search() }
                }
                .onChange(of: viewModel.query) { _, newQuery in
                    guard newQuery.isEmpty else { return }
                    Task { await viewModel.cancelSearch() }
                }
        } else {
            screen
        }
    }

    private var screen: some View {
        VStack(spacing: 12) {
            filters
            content
                .frame(maxHeight: .infinity)
        }
    }

    // MARK: - Filters

    private var filters: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Genres")
                .font(.headline)
                .padding(.horizontal)

            Picker("Category", selection: categoryBinding) {
                ForEach(MediaCategory.allCases) { category in
                    Text(category.title).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    GenreChip(title: "All", isSelected: viewModel.selectedGenreId == nil) {
                        viewModel.selectGenre(nil)
                    }

                    ForEach(viewModel.genres) { genre in
                        GenreChip(title: genre.name, isSelected: viewModel.selectedGenreId == genre.id) {
                            viewModel.selectGenre(genre.id)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
    }

    private var categoryBinding: Binding<MediaCategory> {
        Binding(
            get: { viewModel.category },
            set: { newCategory in
                Task { await viewModel.selectCategory(newCategory) }
            }
        )
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()

        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    Task { await viewModel.loadFirstPage() }
                }
            }
            .padding()

        case .loaded where viewModel.items.isEmpty:
            if viewModel.submittedQuery.isEmpty {
                ContentUnavailableView(
                    "No movies found",
                    systemImage: "film",
                    description: Text("Try another genre.")
                )
            } else {
                ContentUnavailableView.search(text: viewModel.submittedQuery)
            }

        case .loaded:
            List {
                ForEach(viewModel.items) { item in
                    row(for: item)
                        .task {
                            await viewModel.loadNextPageIfNeeded(currentItem: item)
                        }
                }

                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.plain)
        }
    }

    @ViewBuilder
    private func row(for item: MoviesListItemViewModel) -> some View {
        if item.category == .movies {
            NavigationLink(value: Route.movieDetails(movieId: item.id)) {
                MoviesListRow(item: item)
            }
        } else {
            MoviesListRow(item: item)
        }
    }

    // MARK: - Alerts

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

// MARK: - Row

private struct MoviesListRow: View {

    let item: MoviesListItemViewModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.posterURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "film")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 60, height: 90)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(item.releaseInfo)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text(item.rating)
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Genre Chip

private struct GenreChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundStyle(Color.white)
                .background(isSelected ? Color.accentColor : Color.black)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
