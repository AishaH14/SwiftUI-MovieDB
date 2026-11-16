//
//  AccountStatesResponseDTO+Mapping.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct AccountStatesResponseDTO: Decodable {
    let favorite: Bool
    let watchlist: Bool
}

extension AccountStatesResponseDTO {
    func toDomain() -> MovieUserState {
        MovieUserState(
            isFavorite: favorite,
            isInWatchlist: watchlist
        )
    }
}
