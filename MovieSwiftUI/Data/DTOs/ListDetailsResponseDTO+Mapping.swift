//
//  ListDetailsResponseDTO+Mapping.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct ListDetailsResponseDTO: Decodable {
    let id: Int
    let name: String
    let itemCount: Int
    let items: [MovieDTO]
}

// MARK: - Mappings to Domain

extension ListDetailsResponseDTO {
    func toDomain() -> ListDetails {
        ListDetails(
            id: id,
            name: name,
            itemCount: itemCount,
            items: items.map { $0.toDomain() }
        )
    }
}
