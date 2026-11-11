//
//  ListRepositoryError.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum ListRepositoryError: LocalizedError {
    case createFailed

    var errorDescription: String? {
        switch self {
        case .createFailed:
            "Couldn't create the list. Please try again."
        }
    }
}
