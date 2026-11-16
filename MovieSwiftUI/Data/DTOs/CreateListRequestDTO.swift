//
//  CreateListRequestDTO.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

struct CreateListRequestDTO: Encodable {
    let name: String
    let description: String
    let language: String
}
