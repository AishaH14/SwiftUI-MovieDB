//
//  AppFlowCoordinator.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct AppFlowCoordinator: View {

    @State private var authViewModel: AuthViewModel
    private let container: AppDIContainer

    init(container: AppDIContainer) {
        self.container = container
        _authViewModel = State(initialValue: container.authViewModel)
    }

    var body: some View {
        switch authViewModel.authState {
        case .missing:
            WelcomeView(authViewModel: authViewModel)

        case .guest, .signedIn:
            MainTabView(container: container)
        }
    }
}
