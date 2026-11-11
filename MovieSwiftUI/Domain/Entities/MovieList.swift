//
//  MovieList.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct MovieList: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String
    let itemCount: Int
    let posterPath: String?

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)")
    }
}

struct MovieListsPage: Sendable {
    let page: Int
    let totalPages: Int
    let lists: [MovieList]
}
