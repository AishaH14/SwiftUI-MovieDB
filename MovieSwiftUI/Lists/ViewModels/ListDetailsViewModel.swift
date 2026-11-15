//
//  ListDetailsViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class ListDetailsViewModel {

    enum State {
        case loading
        case loaded(ListDetails)
        case failed(String)
    }

    private let listId: Int
    private let fetchListDetailsUseCase: any FetchListDetailsUseCase

    private(set) var state: State = .loading

    init(listId: Int, fetchListDetailsUseCase: any FetchListDetailsUseCase) {
        self.listId = listId
        self.fetchListDetailsUseCase = fetchListDetailsUseCase
    }

    func load() async {
        state = .loading

        do {
            let details = try await fetchListDetailsUseCase.execute(
                listId: listId
            )
            state = .loaded(details)
        } catch is CancellationError {
            // Cancelled: expected, no error shown
        } catch let error as URLError where error.code == .cancelled {
            // Cancelled: expected, no error shown
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
