//
//  DefaultFetchListDetailsUseCase.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation

final class DefaultFetchListDetailsUseCase: FetchListDetailsUseCase {

    private let listRepository: any ListRepository

    init(listRepository: any ListRepository) {
        self.listRepository = listRepository
    }

    func execute(listId: Int) async throws -> ListDetails {
        try await listRepository.fetchListDetails(listId: listId)
    }
}
