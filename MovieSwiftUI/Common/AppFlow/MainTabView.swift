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
    let authViewModel: AuthViewModel
    let makeMovieDetailsViewModel: (Int) -> MovieDetailsViewModel
    let makeListsViewModel: (String) -> ListsViewModel
    let makeSelectListViewModel: (Int, String) -> SelectListViewModel
    let makeMediaListViewModel: (MediaListSource, String) -> MediaListViewModel

    var body: some View {
        TabView {
            HomeView(
                viewModel: homeViewModel,
                authViewModel: authViewModel,
                makeMovieDetailsViewModel: makeMovieDetailsViewModel,
                makeSelectListViewModel: makeSelectListViewModel
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
                authViewModel: authViewModel,
                makeListsViewModel: makeListsViewModel,
                makeMediaListViewModel: makeMediaListViewModel
            )
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
