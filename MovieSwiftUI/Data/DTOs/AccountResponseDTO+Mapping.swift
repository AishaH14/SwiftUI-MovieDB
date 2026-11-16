//
//  AccountResponseDTO+Mapping.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct AccountResponseDTO: Decodable {
    let id: Int
    let username: String
    let name: String?
    let avatar: AvatarDTO?

    struct AvatarDTO: Decodable {
        let tmdb: TMDBAvatarDTO?
    }

    struct TMDBAvatarDTO: Decodable {
        let avatarPath: String?
    }
}

extension AccountResponseDTO {
    func toDomain() -> Account {
        Account(
            id: id,
            username: username,
            avatarPath: avatar?.tmdb?.avatarPath
        )
    }
}
