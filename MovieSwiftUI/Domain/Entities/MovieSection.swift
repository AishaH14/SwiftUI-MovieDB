//
//  MovieSection.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum MovieSection: CaseIterable, Identifiable, Hashable, Sendable {
    case nowPlaying
    case popular
    case topRated
    case upcoming

    var id: Self { self }

    var title: String {
        switch self {
        case .nowPlaying: "Now Playing"
        case .popular: "Popular"
        case .topRated: "Top Rated"
        case .upcoming: "Upcoming"
        }
    }
}
