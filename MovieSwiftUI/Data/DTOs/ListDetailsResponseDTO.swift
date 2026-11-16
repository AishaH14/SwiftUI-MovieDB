//
//  ListDetailsResponseDTO.swift
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
    let items: [ListItemDTO]
}

struct ListItemDTO: Decodable {
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String?
}
