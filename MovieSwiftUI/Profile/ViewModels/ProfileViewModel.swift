//
//  ProfileViewModels.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {

    enum State {
        case guest
        case loading
        case signedIn(Account)
        case failed(String)
    }

    private let fetchAccountUseCase: any FetchAccountUseCase

    private(set) var state: State = .loading

    init(fetchAccountUseCase: any FetchAccountUseCase) {
        self.fetchAccountUseCase = fetchAccountUseCase
    }

    func load(authState: AuthState) async {
        switch authState {
        case .missing, .guest:
            state = .guest

        case .signedIn(let sessionId):
            state = .loading

            do {
                let account = try await fetchAccountUseCase.execute(
                    sessionId: sessionId
                )
                state = .signedIn(account)
            } catch is CancellationError {
                // Cancelled: expected, no error shown
            } catch let error as URLError where error.code == .cancelled {
                // Cancelled: expected, no error shown
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
}
