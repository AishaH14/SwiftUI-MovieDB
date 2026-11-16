//
//  MovieCardItemViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct MovieCardItemViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: URL?
    let rating: String
}

extension MovieCardItemViewModel {
    init(movie: MovieSummary) {
        self.id = movie.id
        self.title = movie.title
        self.posterURL = movie.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w342\($0)")
        }
        self.rating = String(format: "%.1f", movie.rating)
    }
}
