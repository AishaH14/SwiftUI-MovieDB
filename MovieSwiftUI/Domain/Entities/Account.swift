//
//  Account.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct Account: Sendable {
    let id: Int
    let username: String
    let avatarPath: String?

    var avatarURL: URL? {
        guard let avatarPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(avatarPath)")
    }
}
