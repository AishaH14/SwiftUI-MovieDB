//
//  UpdateUserMediaRequestDTO.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation

enum MediaType: String, Encodable {
    case movie
}

struct UpdateFavoriteRequestDTO: Encodable {
    let mediaType: MediaType = .movie
    let mediaId: Int
    let favorite: Bool
}

struct UpdateWatchlistRequestDTO: Encodable {
    let mediaType: MediaType = .movie
    let mediaId: Int
    let watchlist: Bool
}
