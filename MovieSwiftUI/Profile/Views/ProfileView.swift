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
    private let authState: AuthState
    private let onLogout: () -> Void

    init(
        viewModel: ProfileViewModel,
        authState: AuthState,
        onLogout: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.authState = authState
        self.onLogout = onLogout
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
        .task {
            await viewModel.load(authState: authState)
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
                        Task { await viewModel.load(authState: authState) }
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

    private var isSignedIn: Bool {
        if case .signedIn = authState { return true }
        return false
    }

    private var rows: some View {
        VStack(spacing: 0) {
            ProfileRow(title: "Lists", systemImage: "list.bullet.rectangle") {
                // Lists navigation will be added on day two.
            }
            Divider()
            ProfileRow(title: "Favorites", systemImage: "heart") {
                // Implemented in Week 04.
            }
            Divider()
            ProfileRow(title: "Watchlist", systemImage: "bookmark") {
                // Implemented in Week 04.
            }

            if isSignedIn {
                Divider()
                ProfileRow(
                    title: "Logout",
                    systemImage: "rectangle.portrait.and.arrow.right",
                    isDestructive: true,
                    action: onLogout
                )
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Row

private struct ProfileRow: View {

    let title: String
    let systemImage: String
    var isDestructive = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
}
