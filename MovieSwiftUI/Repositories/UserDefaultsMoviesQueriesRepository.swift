//
//  UserDefaultsMoviesQueriesRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class UserDefaultsMoviesQueriesRepository: MoviesQueriesRepository {

    private enum Keys {
        static let recentQueries = "recent_movie_queries"
    }

    private let userDefaults: UserDefaults
    private let maxStorageLimit: Int

    init(userDefaults: UserDefaults = .standard, maxStorageLimit: Int = 10) {
        self.userDefaults = userDefaults
        self.maxStorageLimit = maxStorageLimit
    }

    func fetchRecentQueries(maxCount: Int) -> [String] {
        Array(storedQueries.prefix(maxCount))
    }

    func saveRecentQuery(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        var queries = storedQueries.filter {
            $0.caseInsensitiveCompare(trimmedQuery) != .orderedSame
        }
        queries.insert(trimmedQuery, at: 0)
        userDefaults.set(Array(queries.prefix(maxStorageLimit)), forKey: Keys.recentQueries)
    }

    // MARK: - Private

    private var storedQueries: [String] {
        userDefaults.stringArray(forKey: Keys.recentQueries) ?? []
    }
}
