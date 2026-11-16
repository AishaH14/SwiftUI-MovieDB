//
//  Route.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 06/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum Route: Hashable {
    case movieDetails(movieId: Int)
    case moviesList(MoviesListSource)
    case lists
    case mediaList(MediaListSource)
    case signIn(SignInPrompt)
}

struct SignInPrompt: Hashable {
    let navigationTitle: String
    let title: String
    let message: String
}

extension SignInPrompt {
    static let account = SignInPrompt(
        navigationTitle: "Sign In",
        title: "Sign in to TMDB",
        message: "Sign in to sync your lists, favorites and watchlist."
    )

    static let lists = SignInPrompt(
        navigationTitle: "My Lists",
        title: "Sign in to use My Lists",
        message: "Sign in to TMDB to create and manage your lists."
    )

    static let favorites = SignInPrompt(
        navigationTitle: "Favorites",
        title: "Sign in to use Favorites",
        message: "Sign in to TMDB to save your favorite movies."
    )

    static let watchlist = SignInPrompt(
        navigationTitle: "Watchlist",
        title: "Sign in to use Watchlist",
        message: "Sign in to TMDB to keep track of movies you want to watch."
    )

    static let saveMovies = SignInPrompt(
        navigationTitle: "Sign In",
        title: "Sign in to save movies",
        message: "Sign in to TMDB to add movies to your favorites, watchlist and lists."
    )
}
