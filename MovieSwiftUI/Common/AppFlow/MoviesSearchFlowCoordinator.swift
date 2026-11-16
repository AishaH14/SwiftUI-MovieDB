//
//  MoviesSearchFlowCoordinator.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct MoviesSearchFlowCoordinator: View {

    @State private var router = Router()
    @State private var viewModel: MoviesListViewModel
    private let container: AppDIContainer

    init(container: AppDIContainer) {
        self.container = container
        _viewModel = State(initialValue: container.movieContainer.makeMoviesListViewModel(source: .search))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            MoviesListView(viewModel: viewModel)
                .navigationDestination(for: Route.self) { route in
                    RouteDestinationView(route: route, container: container)
                }
        }
        .environment(router)
    }
}
