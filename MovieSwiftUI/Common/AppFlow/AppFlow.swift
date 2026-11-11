//
//  AppFlow.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

struct AppRootView: View {

    @State private var authViewModel: AuthViewModel
    private let homeViewModel: HomeViewModel
    private let profileViewModel: ProfileViewModel
    private let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel

    init(
        authViewModel: AuthViewModel,
        homeViewModel: HomeViewModel,
        profileViewModel: ProfileViewModel,
        makeMovieDetailsViewModel: @escaping (Int) -> MovieDetailsViewModel
    ) {
        _authViewModel = State(initialValue: authViewModel)
        self.homeViewModel = homeViewModel
        self.profileViewModel = profileViewModel
        self.makeMovieDetailsViewModel = makeMovieDetailsViewModel
    }

    var body: some View {
        Group {
            switch authViewModel.authState {

            case .missing:
                WelcomeView(authViewModel: authViewModel)

            case .guest, .signedIn:
                MainTabView(
                    homeViewModel: homeViewModel,
                    profileViewModel: profileViewModel,
                    authState: authViewModel.authState,
                    makeMovieDetailsViewModel: makeMovieDetailsViewModel,
                    onLogout: authViewModel.signOut
                )
            }
        }
    }
}
