//
//  MovieCardView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieCardView: View {

    let movie: MovieSummary

    private var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            poster

            Text(movie.title)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)

                Text(movie.rating, format: .number.precision(.fractionLength(1)))
                    .foregroundStyle(.primary)
            }
            .font(.caption)
        }
        .frame(width: 110, alignment: .leading)
    }

    private var poster: some View {
        AsyncImage(url: posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "film")
                    .foregroundStyle(.secondary)
            case .empty:
                Color.clear
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 110, height: 150)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MovieCardView(
        movie: MovieSummary(
            id: 1,
            title: "The Dark Knight",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            rating: 8.5
        )
    )
}
