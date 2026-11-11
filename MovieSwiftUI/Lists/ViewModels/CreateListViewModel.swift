//
//  CreateListViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation
import Observation

@MainActor
@Observable
final class CreateListViewModel {

    static let nameLimit = 50
    static let descriptionLimit = 200

    private let sessionId: String
    private let createListUseCase: any CreateListUseCase

    var name = ""
    var description = ""
    

    private(set) var isCreating = false
    private(set) var errorMessage: String?

    var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isCreating
    }

    init(sessionId: String, createListUseCase: any CreateListUseCase) {
        self.sessionId = sessionId
        self.createListUseCase = createListUseCase
    }

    /// Returns true when the list is created.
    func create() async -> Bool {
        guard canCreate else { return false }

        isCreating = true
        errorMessage = nil
        defer { isCreating = false }

        do {
            _ = try await createListUseCase.execute(
                sessionId: sessionId,
                name: name,
                description: description
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
