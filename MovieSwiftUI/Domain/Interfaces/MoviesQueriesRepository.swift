//
//  MoviesQueriesRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol MoviesQueriesRepository {
    func fetchRecentQueries(maxCount: Int) -> [String]
    func saveRecentQuery(_ query: String)
}
