//
//  MovieCardSkeletonView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieCardSkeletonView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 110, height: 150)

            Text("Movie title")
                .font(.subheadline)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")

                Text("0.0")
            }
            .font(.caption)
        }
        .frame(width: 110, alignment: .leading)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    MovieCardSkeletonView()
}
