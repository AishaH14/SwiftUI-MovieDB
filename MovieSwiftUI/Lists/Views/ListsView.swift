//
//  ListsView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct ListsView: View {

    @State private var viewModel: ListsViewModel
    @State private var isShowingCreateList = false
    @State private var listToDelete: MovieList?

    init(viewModel: ListsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle("My Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingCreateList = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create list")
                }
            }
            .sheet(isPresented: $isShowingCreateList) {
                CreateListView(viewModel: viewModel.makeCreateListViewModel()) {
                    Task { await viewModel.loadFirstPage() }
                }
            }
            .alert(
                "Delete \"\(listToDelete?.name ?? "")\"?",
                isPresented: isShowingDeleteAlert,
                presenting: listToDelete
            ) { list in
                Button("Delete", role: .destructive) {
                    Task { await viewModel.deleteList(list) }
                }
                Button("Cancel", role: .cancel) { }
            } message: { _ in
                Text("This list and all its movies will be permanently deleted. This action cannot be undone.")
            }
            .alert(
                "Couldn't delete the list",
                isPresented: isShowingDeleteError
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.deleteErrorMessage ?? "")
            }
            .task {
                await viewModel.loadFirstPage()
            }
    }

    // MARK: - Alerts

    private var isShowingDeleteAlert: Binding<Bool> {
        Binding(
            get: { listToDelete != nil },
            set: { if !$0 { listToDelete = nil } }
        )
    }

    private var isShowingDeleteError: Binding<Bool> {
        Binding(
            get: { viewModel.deleteErrorMessage != nil },
            set: { if !$0 { viewModel.deleteErrorMessage = nil } }
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

        case .loaded where viewModel.lists.isEmpty:
            ContentUnavailableView(
                "No lists yet",
                systemImage: "list.bullet.rectangle",
                description: Text("Tap + to create your first list.")
            )

        case .loaded:
            List {
                ForEach(viewModel.lists) { list in
                    ListRow(list: list)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                listToDelete = list
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .task {
                            await viewModel.loadNextPageIfNeeded(currentList: list)
                        }
                }

                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

// MARK: - Row

private struct ListRow: View {

    let list: MovieList

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: list.posterURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "film")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 48, height: 64)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(.headline)
                Text("\(list.itemCount) movies")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
