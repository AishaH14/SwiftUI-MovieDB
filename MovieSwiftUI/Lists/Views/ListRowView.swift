//
//  ListRowView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct ListRowView: View {

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
                Text("\(list.itemCount) \(list.itemCount == 1 ? "movie" : "movies")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
