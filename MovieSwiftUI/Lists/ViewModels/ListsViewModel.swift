//
//  ListsViewModel.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//
import Foundation
import Observation

@MainActor
@Observable
final class ListsViewModel {

    enum State {
        case loading
        case loaded
        case failed(String)
    }

    private let sessionId: String
    private let fetchListsUseCase: any FetchListsUseCase
    private let deleteListUseCase: any DeleteListUseCase
    private let createListViewModelFactory: () -> CreateListViewModel

    private(set) var state: State = .loading
    private(set) var lists: [MovieList] = []
    private(set) var isLoadingNextPage = false
    var deleteErrorMessage: String?

    private var currentPage = 0
    private var totalPages = 1

    init(
        sessionId: String,
        fetchListsUseCase: any FetchListsUseCase,
        deleteListUseCase: any DeleteListUseCase,
        makeCreateListViewModel: @escaping () -> CreateListViewModel
    ) {
        self.sessionId = sessionId
        self.fetchListsUseCase = fetchListsUseCase
        self.deleteListUseCase = deleteListUseCase
        self.createListViewModelFactory = makeCreateListViewModel
    }

    func makeCreateListViewModel() -> CreateListViewModel {
        createListViewModelFactory()
    }

    // MARK: - Loading

    func loadFirstPage() async {
        state = .loading
        currentPage = 0
        totalPages = 1

        do {
            let page = try await fetchListsUseCase.execute(
                sessionId: sessionId,
                page: 1
            )
            lists = page.lists
            currentPage = page.page
            totalPages = page.totalPages
            state = .loaded
        } catch is CancellationError {
            // Cancelled: expected, no error shown
        } catch let error as URLError where error.code == .cancelled {
            // Cancelled: expected, no error shown
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func loadNextPageIfNeeded(currentList: MovieList) async {
        guard currentList.id == lists.last?.id,
              currentPage < totalPages,
              !isLoadingNextPage else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let page = try await fetchListsUseCase.execute(
                sessionId: sessionId,
                page: currentPage + 1
            )
            lists.append(contentsOf: page.lists)
            currentPage = page.page
            totalPages = page.totalPages
        } catch {
            // Keep current lists; the next scroll will try again.
        }
    }

    // MARK: - Delete

    func deleteList(_ list: MovieList) async {
        do {
            try await deleteListUseCase.execute(
                listId: list.id,
                sessionId: sessionId
            )
            lists.removeAll { $0.id == list.id }
        } catch {
            // TMDB can return an error even when the list was deleted,
            // so reload to show the real state.
            await loadFirstPage()

            if lists.contains(where: { $0.id == list.id }) {
                deleteErrorMessage = error.localizedDescription
            }
        }
    }
}
