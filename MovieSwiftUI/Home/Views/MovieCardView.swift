//
//  MovieCardView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieCardView: View {

    let item: MovieCardItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            poster

            Text(item.title)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)

                Text(item.rating)
                    .foregroundStyle(.primary)
            }
            .font(.caption)
        }
        .frame(width: 110, alignment: .leading)
    }

    private var poster: some View {
        AsyncImage(url: item.posterURL) { phase in
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
        item: MovieCardItemViewModel(
            id: 1,
            title: "The Dark Knight",
            posterURL: nil,
            rating: "8.5"
        )
    )
}
