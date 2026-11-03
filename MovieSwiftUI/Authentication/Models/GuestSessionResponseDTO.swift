//
//  GuestSessionResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

struct GuestSessionResponseDTO: Decodable {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String

}
