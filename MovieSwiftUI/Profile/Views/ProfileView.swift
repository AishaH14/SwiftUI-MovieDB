//
//  ProfileView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel
    private let authViewModel: AuthViewModel
    private let makeListsViewModel: (String) -> ListsViewModel

    init(
        viewModel: ProfileViewModel,
        authViewModel: AuthViewModel,
        makeListsViewModel: @escaping (String) -> ListsViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.authViewModel = authViewModel
        self.makeListsViewModel = makeListsViewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    rows
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Reloads the header after signing in from a sign-in page.
        .task(id: authViewModel.isSignedIn) {
            await viewModel.load(authState: authViewModel.authState)
        }
    }

    // MARK: - Header

    @ViewBuilder
    private var header: some View {
        HStack(spacing: 16) {
            switch viewModel.state {
            case .guest:
                avatar(url: nil)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Guest User")
                        .font(.headline)
                    Text("Not signed in to TMDB")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 64)

            case .signedIn(let account):
                avatar(url: account.avatarURL)
                Text(account.username)
                    .font(.headline)

            case .failed(let message):
                VStack(spacing: 8) {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await viewModel.load(authState: authViewModel.authState) }
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func avatar(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            if case .success(let image) = phase {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 64, height: 64)
        .background(Color.gray.opacity(0.5))
        .clipShape(Circle())
    }

    // MARK: - Rows

    private var sessionId: String? {
        if case .signedIn(let sessionId) = authViewModel.authState { return sessionId }
        return nil
    }

    private var rows: some View {
        VStack(spacing: 0) {
            listsRow
            Divider()
            favoritesRow
            Divider()
            watchlistRow

            if sessionId != nil {
                Divider()
                Button {
                    authViewModel.signOut()
                } label: {
                    ProfileRowLabel(
                        title: "Logout",
                        systemImage: "rectangle.portrait.and.arrow.right",
                        isDestructive: true
                    )
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var listsRow: some View {
        if let sessionId {
            NavigationLink {
                ListsView(viewModel: makeListsViewModel(sessionId))
            } label: {
                ProfileRowLabel(title: "Lists", systemImage: "list.bullet.rectangle")
            }
        } else {
            guestRow(
                title: "Lists",
                navigationTitle: "My Lists",
                systemImage: "list.bullet.rectangle",
                message: "Sign in to TMDB to create and manage your lists."
            )
        }
    }

    @ViewBuilder
    private var favoritesRow: some View {
        if sessionId != nil {
            // Favorites screen is planned for Week 04.
            Button {} label: {
                ProfileRowLabel(title: "Favorites", systemImage: "heart")
            }
        } else {
            guestRow(
                title: "Favorites",
                navigationTitle: "Favorites",
                systemImage: "heart",
                message: "Sign in to TMDB to save your favorite movies."
            )
        }
    }

    @ViewBuilder
    private var watchlistRow: some View {
        if sessionId != nil {
            // Watchlist screen is planned for Week 04.
            Button {} label: {
                ProfileRowLabel(title: "Watchlist", systemImage: "bookmark")
            }
        } else {
            guestRow(
                title: "Watchlist",
                navigationTitle: "Watchlist",
                systemImage: "bookmark",
                message: "Sign in to TMDB to keep track of movies you want to watch."
            )
        }
    }

    private func guestRow(
        title: String,
        navigationTitle: String,
        systemImage: String,
        message: String
    ) -> some View {
        NavigationLink {
            SignInPromptView(
                authViewModel: authViewModel,
                navigationTitle: navigationTitle,
                title: "Sign in to use \(navigationTitle)",
                message: message
            )
        } label: {
            ProfileRowLabel(title: title, systemImage: systemImage)
        }
    }
}

// MARK: - Row Label

private struct ProfileRowLabel: View {

    let title: String
    let systemImage: String
    var isDestructive = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24)
            Text(title)
            Spacer()
            if !isDestructive {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
        }
        .foregroundStyle(isDestructive ? Color.red : Color.primary)
        .padding()
    }
}
