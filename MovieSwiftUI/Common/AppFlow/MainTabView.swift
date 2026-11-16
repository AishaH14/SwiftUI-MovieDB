//
//  MainTabView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 30/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MainTabView: View {

    let container: AppDIContainer

    var body: some View {
        TabView {
            HomeFlowCoordinator(container: container)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MoviesSearchFlowCoordinator(container: container)
                .tabItem {
                    Label("Movies", systemImage: "magnifyingglass")
                }

            ProfileFlowCoordinator(container: container)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
