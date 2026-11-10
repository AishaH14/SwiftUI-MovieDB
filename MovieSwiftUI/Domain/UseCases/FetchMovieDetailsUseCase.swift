//
//  FetchMovieDetailsUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 24/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol FetchMovieDetailsUseCase {
    func execute(movieId: Int) async throws -> MovieSummary
}
