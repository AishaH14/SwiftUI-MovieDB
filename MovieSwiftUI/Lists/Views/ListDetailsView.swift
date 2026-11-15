//
//  ListDetailsView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct ListDetailsView: View {

    @State private var viewModel: ListDetailsViewModel

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    init(viewModel: ListDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load()
            }
    }

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
                    Task { await viewModel.load() }
                }
            }
            .padding()

        case .loaded(let details):
            ScrollView {
                VStack(spacing: 16) {
                    header(for: details)

                    if details.items.isEmpty {
                        ContentUnavailableView(
                            "No movies yet",
                            systemImage: "film",
                            description: Text("Movies you add to this list will appear here.")
                        )
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(details.items) { item in
                                ListItemCell(item: item)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(details.name)
        }
    }

    private func header(for details: ListDetails) -> some View {
        Text("\(details.itemCount) movies • Public")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Cell

private struct ListItemCell: View {

    let item: ListItem

    var body: some View {
        VStack(spacing: 6) {
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
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}
