//
//  ListsResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct ListsResponseDTO: Decodable {
    let page: Int
    let totalPages: Int
    let results: [ListDTO]
}

struct ListDTO: Decodable {
    let id: Int
    let name: String
    let description: String?
    let itemCount: Int
    let posterPath: String?
}
