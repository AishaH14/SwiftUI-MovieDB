//
//  CreateListView.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct CreateListView: View {

    @State private var viewModel: CreateListViewModel
    @Environment(\.dismiss) private var dismiss
    private let onCreated: () -> Void

    init(viewModel: CreateListViewModel, onCreated: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onCreated = onCreated
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter list name", text: $viewModel.name)
                } header: {
                    Text("Name")
                } footer: {
                    counter(viewModel.name.count, CreateListViewModel.nameLimit)
                }

                Section {
                    TextField(
                        "Enter list description",
                        text: $viewModel.description,
                        axis: .vertical
                    )
                    .lineLimit(4...8)
                } header: {
                    Text("Description (Optional)")
                } footer: {
                    counter(viewModel.description.count, CreateListViewModel.descriptionLimit)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Create List")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.name) { _, newValue in
                if newValue.count > CreateListViewModel.nameLimit {
                    viewModel.name = String(newValue.prefix(CreateListViewModel.nameLimit))
                }
            }
            .onChange(of: viewModel.description) { _, newValue in
                if newValue.count > CreateListViewModel.descriptionLimit {
                    viewModel.description = String(newValue.prefix(CreateListViewModel.descriptionLimit))
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isCreating {
                        ProgressView()
                    } else {
                        Button("Create") {
                            Task {
                                if await viewModel.create() {
                                    onCreated()
                                    dismiss()
                                }
                            }
                        }
                        .disabled(!viewModel.canCreate)
                    }
                }
            }
        }
    }

    private func counter(_ count: Int, _ limit: Int) -> some View {
        Text("\(count)/\(limit)")
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
