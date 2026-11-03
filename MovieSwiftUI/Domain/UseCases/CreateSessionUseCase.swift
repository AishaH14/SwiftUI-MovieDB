//
//  CreateSessionUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

protocol CreateSessionUseCase {
    func execute(requestToken: String) async throws -> String
}
