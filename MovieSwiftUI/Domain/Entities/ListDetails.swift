//
//  ListDetails.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct ListDetails: Sendable {
    let id: Int
    let name: String
    let itemCount: Int
    let items: [ListItem]
}

struct ListItem: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let posterPath: String?

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
    }
}
