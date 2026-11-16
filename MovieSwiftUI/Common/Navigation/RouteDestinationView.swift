//
//  RouteDestinationView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

/// Builds the screen for every route, so views only describe where to go.
struct RouteDestinationView: View {

    let route: Route
    let container: AppDIContainer

    private var authViewModel: AuthViewModel { container.authViewModel }

    var body: some View {
        switch route {
        case .movieDetails(let movieId):
            MovieDetailsView(
                viewModel: container.movieContainer.makeMovieDetailsViewModel(movieId: movieId),
                authViewModel: authViewModel,
                makeSelectListViewModel: { movieId, sessionId in
                    container.profileContainer.makeSelectListViewModel(movieId: movieId, sessionId: sessionId)
                }
            )

        case .moviesList(let source):
            MoviesListView(
                viewModel: container.movieContainer.makeMoviesListViewModel(source: source)
            )

        case .lists:
            if let sessionId = authViewModel.sessionId {
                ListsView(
                    viewModel: container.profileContainer.makeListsViewModel(sessionId: sessionId)
                )
            } else {
                signInView(.lists)
            }

        case .mediaList(let source):
            if let sessionId = authViewModel.sessionId {
                MediaListView(
                    viewModel: container.profileContainer.makeMediaListViewModel(source: source, sessionId: sessionId)
                )
            } else {
                signInView(.saveMovies)
            }

        case .signIn(let prompt):
            signInView(prompt)
        }
    }

    private func signInView(_ prompt: SignInPrompt) -> some View {
        SignInPromptView(
            authViewModel: authViewModel,
            navigationTitle: prompt.navigationTitle,
            title: prompt.title,
            message: prompt.message
        )
    }
}
