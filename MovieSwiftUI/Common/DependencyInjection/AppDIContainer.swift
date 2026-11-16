//
//  AppDIContainer.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

@MainActor
final class AppDIContainer {

    let authContainer: AuthDIContainer
    let movieContainer: MovieDIContainer
    let profileContainer: ProfileDIContainer

    lazy var authViewModel: AuthViewModel = authContainer.makeAuthViewModel()

    init() {
        guard let baseURL = URL(string: "https://api.themoviedb.org/3") else {
            fatalError("Invalid TMDB base URL")
        }

        let networkClient = URLSessionNetworkClient(
            baseURL: baseURL,
            apiKey: Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
        )
        let accountRepository = DefaultAccountRepository(networkClient: networkClient)

        self.authContainer = AuthDIContainer(networkClient: networkClient)
        self.movieContainer = MovieDIContainer(
            networkClient: networkClient,
            accountRepository: accountRepository
        )
        self.profileContainer = ProfileDIContainer(
            networkClient: networkClient,
            accountRepository: accountRepository
        )
    }
}
