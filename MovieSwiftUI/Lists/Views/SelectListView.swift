//
//  SelectListView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct SelectListView: View {

    @State private var viewModel: SelectListViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: SelectListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            header
            content
            addButton
        }
        .padding(20)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .task {
            await viewModel.load()
        }
        .alert("Error", isPresented: isShowingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Add to List")
                .font(.title2.bold())

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .background(Color(.tertiarySystemFill))
                    .clipShape(Circle())
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded where viewModel.lists.isEmpty:
            ContentUnavailableView(
                "No lists yet",
                systemImage: "list.bullet.rectangle",
                description: Text("Create a list from your profile first.")
            )

        case .loaded:
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.lists) { list in
                        Button {
                            viewModel.toggle(list)
                        } label: {
                            SelectListRow(list: list, isSelected: viewModel.isSelected(list))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    Task { await viewModel.load() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            Task {
                if await viewModel.save() { dismiss() }
            }
        } label: {
            Group {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Text("Add to List")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!viewModel.hasChanges || viewModel.isSaving)
    }

    // MARK: - Alerts

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

// MARK: - Row

private struct SelectListRow: View {

    let list: MovieList
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)

            ListRowView(list: list)

            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
