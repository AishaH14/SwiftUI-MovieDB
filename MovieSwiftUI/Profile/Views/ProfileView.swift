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

    init(viewModel: ProfileViewModel, authViewModel: AuthViewModel) {
        _viewModel = State(initialValue: viewModel)
        self.authViewModel = authViewModel
    }

    var body: some View {
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

                    NavigationLink(value: Route.signIn(.account)) {
                        Text("Sign In")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
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

    private var sessionId: String? { authViewModel.sessionId }

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

    private var listsRow: some View {
        row(
            title: "Lists",
            systemImage: "list.bullet.rectangle",
            route: .lists,
            guestPrompt: .lists
        )
    }

    private var favoritesRow: some View {
        row(
            title: "Favorites",
            systemImage: "heart",
            route: .mediaList(.favorites),
            guestPrompt: .favorites
        )
    }

    private var watchlistRow: some View {
        row(
            title: "Watchlist",
            systemImage: "bookmark",
            route: .mediaList(.watchlist),
            guestPrompt: .watchlist
        )
    }

    /// Signed-in users open the page, guests open the sign-in page.
    private func row(
        title: String,
        systemImage: String,
        route: Route,
        guestPrompt: SignInPrompt
    ) -> some View {
        NavigationLink(value: sessionId == nil ? .signIn(guestPrompt) : route) {
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
