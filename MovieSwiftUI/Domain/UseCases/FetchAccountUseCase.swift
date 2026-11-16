//
//  FetchAccountUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol FetchAccountUseCase {
    func execute(sessionId: String) async throws -> Account
}
