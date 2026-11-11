//
//  MainTabView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MainTabView: View {

    let homeViewModel: HomeViewModel
    let profileViewModel: ProfileViewModel
    let authState: AuthState
    let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel
    let onLogout: () -> Void

    var body: some View {
        TabView {
            HomeView(
                viewModel: homeViewModel,
                makeMovieDetailsViewModel: makeMovieDetailsViewModel
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }

            Search()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            ProfileView(
                viewModel: profileViewModel,
                authState: authState,
                onLogout: onLogout
            )
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
