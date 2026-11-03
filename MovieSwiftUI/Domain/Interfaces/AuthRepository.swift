//
//  AuthRepository.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

protocol AuthRepository {

    // Guest Authentication
    func createGuestSession() async throws -> String

    // User Authentication
    func createRequestToken() async throws -> String

    func createSession(
        requestToken: String
    ) async throws -> String
}
