//
//  MediaListView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MediaListView: View {

    @State private var viewModel: MediaListViewModel
    @State private var isEditing = false
    @State private var selectedIds: Set<Int> = []
    @State private var isShowingDeleteConfirmation = false

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    init(viewModel: MediaListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(isEditing)
            .toolbar { toolbarContent }
            .overlay(alignment: .bottom) { toast }
            .alert("Delete Movies", isPresented: $isShowingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task { await deleteSelectedMovies() }
                }
            } message: {
                Text("Are you sure you want to delete \(selectedIds.count) movie(s)?")
            }
            .alert("Error", isPresented: isShowingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task {
                await viewModel.loadFirstPage()
            }
            .task(id: viewModel.toastMessage) {
                guard viewModel.toastMessage != nil else { return }
                try? await Task.sleep(for: .seconds(2))
                withAnimation { viewModel.toastMessage = nil }
            }
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

        case .loaded where viewModel.movies.isEmpty:
            ContentUnavailableView(
                "No movies yet",
                systemImage: "film",
                description: Text("Movies you add will appear here.")
            )

        case .loaded:
            ScrollView {
                VStack(spacing: 16) {
                    Text(infoText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            MediaListCell(
                                movie: movie,
                                isEditing: isEditing,
                                isSelected: selectedIds.contains(movie.id)
                            )
                            .onTapGesture {
                                guard isEditing else { return }
                                toggleSelection(of: movie)
                            }
                            .task {
                                await viewModel.loadNextPageIfNeeded(currentMovie: movie)
                            }
                        }
                    }

                    if viewModel.isLoadingNextPage {
                        ProgressView()
                    }
                }
                .padding()
            }
        }
    }

    private var infoText: String {
        let count = viewModel.itemCount
        let movies = "\(count) \(count == 1 ? "movie" : "movies")"

        if case .list = viewModel.source {
            return "\(movies) • Public"
        }
        return movies
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if isEditing {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    stopEditing()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Delete", role: .destructive) {
                    isShowingDeleteConfirmation = true
                }
                .disabled(selectedIds.isEmpty || viewModel.isDeleting)
            }
        } else if !viewModel.movies.isEmpty {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
    }

    // MARK: - Toast

    @ViewBuilder
    private var toast: some View {
        if let message = viewModel.toastMessage {
            Text(message)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(Capsule())
                .padding(.bottom, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: - Editing

    private func toggleSelection(of movie: MovieCardItemViewModel) {
        if selectedIds.contains(movie.id) {
            selectedIds.remove(movie.id)
        } else {
            selectedIds.insert(movie.id)
        }
    }

    private func deleteSelectedMovies() async {
        await viewModel.deleteMovies(withIds: selectedIds)
        stopEditing()
    }

    private func stopEditing() {
        isEditing = false
        selectedIds.removeAll()
    }

    // MARK: - Alerts

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

// MARK: - Cell

private struct MediaListCell: View {

    let movie: MovieCardItemViewModel
    let isEditing: Bool
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: movie.posterURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "film")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .topTrailing) {
                if isEditing {
                    selectionIndicator
                }
            }

            Text(movie.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    private var selectionIndicator: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.title3)
            .foregroundStyle(isSelected ? Color.accentColor : Color.white)
            .background(Circle().fill(isSelected ? Color.white : Color.black.opacity(0.3)))
            .padding(6)
    }
}
