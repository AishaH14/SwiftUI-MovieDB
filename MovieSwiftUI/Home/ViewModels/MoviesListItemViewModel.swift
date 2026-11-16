//
//  MoviesListItemViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct MoviesListItemViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let releaseInfo: String
    let posterURL: URL?
    let rating: String
    let genreIds: [Int]
    let category: MediaCategory
}

extension MoviesListItemViewModel {
    init(movie: MovieSummary, category: MediaCategory) {
        self.id = movie.id
        self.title = movie.title
        self.posterURL = movie.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w185\($0)")
        }
        self.rating = String(format: "%.1f", movie.rating)
        self.genreIds = movie.genreIds
        self.category = category

        let type = category == .movies ? "Movie" : "TV Show"
        if let year = movie.releaseDate?.prefix(4), !year.isEmpty {
            self.releaseInfo = "\(year) • \(type)"
        } else {
            self.releaseInfo = type
        }
    }
}
