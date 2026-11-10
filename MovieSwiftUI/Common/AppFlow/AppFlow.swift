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
    private let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel

    init(
        authViewModel: AuthViewModel,
        homeViewModel: HomeViewModel,
        makeMovieDetailsViewModel: @escaping (Int) -> MovieDetailsViewModel
    ) {
        _authViewModel = State(initialValue: authViewModel)
        self.homeViewModel = homeViewModel
        self.makeMovieDetailsViewModel = makeMovieDetailsViewModel
    }

    var body: some View {
        Group {
            switch authViewModel.authState {

            case .missing:
                WelcomeView(authViewModel: authViewModel)

            case .guest, .signedIn:
                HomeView(
                    viewModel: homeViewModel,
                    makeMovieDetailsViewModel: makeMovieDetailsViewModel
                )
            }
        }
    }
}
