//
//  FeedViewModel.swift
//  TestTask
//
//  Created by Nadira Seitkazy  on 09.12.2025.
//
import Foundation

final class FeedViewModel {

    // MARK: - Output closures (binding to VC)
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Data
    private var allPosts: [Post] = []
    private(set) var displayedPosts: [Post] = []

    // Pagination
    private var cursor: Int = 0
    private let pageSize: Int = 20

    // MARK: - Load initial data
    func loadFeed() {
        NetworkService.shared.getPosts { [weak self] result in
                switch result {
                case .success(let posts):
                    self?.allPosts = posts
                    self?.savePostsToCoreData(posts)   // сохраняем оффлайн
                    self?.resetPagination()
                    self?.onDataUpdated?()

                case .failure(_):
                    self?.loadPostsFromCoreData()     // если нет сети, показываем оффлайн
                    self?.onError?("Failed to load from network, showing offline data.")
                }
            }
    }

    // Pull-to-refresh
    func refresh() {
        cursor = 0
        displayedPosts = []
        loadFeed()
    }

    // MARK: - Pagination
    private func resetPagination() {
        cursor = 0
        displayedPosts = []
        loadMore()
    }

    func loadMore() {
        let nextIndex = cursor + pageSize
        let endIndex = min(nextIndex, allPosts.count)

        guard cursor < endIndex else { return }

        let slice = allPosts[cursor..<endIndex]
        displayedPosts.append(contentsOf: slice)

        cursor = endIndex
        onDataUpdated?()
    }
}

