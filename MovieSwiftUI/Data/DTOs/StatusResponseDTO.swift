//
//  StatusResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct StatusResponseDTO: Decodable {
    let statusCode: Int
    let statusMessage: String
}
