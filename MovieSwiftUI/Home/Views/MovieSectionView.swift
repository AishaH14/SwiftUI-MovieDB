//
//  MovieSectionView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieSectionView: View {

    let section: MovieSection
    let state: HomeViewModel.SectionState
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            content
        }
    }

    private var header: some View {
        HStack {
            Text(section.title)
                .font(.headline)

            Spacer()

            NavigationLink(value: Route.moviesList(.section(section))) {
                Text("See All")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(0..<5, id: \.self) { _ in
                        MovieCardSkeletonView()
                    }
                }
                .padding(.horizontal)
            }
            .scrollDisabled(true)
            
        case .loaded(let movies) where movies.isEmpty:
            Text("No movies available.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 210)

        case .loaded(let items):
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(items) { item in
                        NavigationLink(value: Route.movieDetails(movieId: item.id)) {
                            MovieCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }

        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry", action: onRetry)
            }
            .frame(maxWidth: .infinity, minHeight: 210)
            .padding(.horizontal)
        }
    }
}
