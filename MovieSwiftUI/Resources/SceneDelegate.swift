//
//  SceneDelegate.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 05/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        // MARK: - Authentication Dependencies

        guard let baseURL = URL(
            string: "https://api.themoviedb.org/3"
        ) else {
            return
        }

        let networkClient = URLSessionNetworkClient(
            baseURL: baseURL,
            apiKey: Bundle.main.object(
                forInfoDictionaryKey: "TMDB_API_KEY"
            ) as? String ?? ""
        )

        let authContainer = AuthDIContainer(
            networkClient: networkClient
        )

        let authViewModel = authContainer.makeAuthViewModel()

        // MARK: - Home Dependencies

        let movieStore = MovieStore.shared
        let movieContainer = MovieDIContainer(
            networkClient: networkClient
        )
        let profileContainer = ProfileDIContainer(
            networkClient: networkClient
        )

        let rootView = AppRootView(
            authViewModel: authViewModel,
            homeViewModel: movieContainer.makeHomeViewModel(),
            profileViewModel: profileContainer.makeProfileViewModel(),
            makeMovieDetailsViewModel: { movieId in
                movieContainer.makeMovieDetailsViewModel(movieId: movieId)
            },
            makeListsViewModel: { sessionId in
                profileContainer.makeListsViewModel(sessionId: sessionId)
            }
        )
        .environmentObject(
            MovieSearchData(movieService: movieStore)
        )
        .environmentObject(KeyboardData())

        // MARK: - Window Setup

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.rootViewController = UIHostingController(
                rootView: rootView
            )

            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

