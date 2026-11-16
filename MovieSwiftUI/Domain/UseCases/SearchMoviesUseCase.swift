//
//  SearchMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(query: String, category: MediaCategory, page: Int) async throws -> MoviesPage
    func fetchRecentQueries() -> [String]
    func fetchGenres(category: MediaCategory) async throws -> [Genre]
}
