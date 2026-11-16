//
//  CreateListUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol CreateListUseCase {
    func execute(
        sessionId: String,
        name: String,
        description: String
    ) async throws -> Int
}
