//
//  ProfileFlowCoordinator.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct ProfileFlowCoordinator: View {

    @State private var router = Router()
    @State private var viewModel: ProfileViewModel
    private let container: AppDIContainer

    init(container: AppDIContainer) {
        self.container = container
        _viewModel = State(initialValue: container.profileContainer.makeProfileViewModel())
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ProfileView(viewModel: viewModel, authViewModel: container.authViewModel)
                .navigationDestination(for: Route.self) { route in
                    RouteDestinationView(route: route, container: container)
                }
        }
        .environment(router)
    }
}
