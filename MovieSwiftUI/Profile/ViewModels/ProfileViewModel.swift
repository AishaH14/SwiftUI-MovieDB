//
//  ProfileViewModel.swift
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
        case .guest:
            state = .guest

        case .missing:
            break

        case .signedIn(let sessionId):
            state = .loading
            do {
                let account = try await fetchAccountUseCase.execute(sessionId: sessionId)
                state = .signedIn(account)
            } catch {
                handle(error: error)
            }
        }
    }

    private func handle(error: Error) {
        guard !error.isCancellation else { return }
        state = .failed(
            error.isInternetConnectionError
                ? "No internet connection"
                : "Failed loading account details"
        )
    }
        }
