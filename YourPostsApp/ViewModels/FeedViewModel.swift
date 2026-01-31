//
//  FeedViewModel.swift
//  YourPostsApp
//

import Foundation

final class FeedViewModel {

    private let networkService = NetworkService()

    private(set) var posts: [Post] = []
    private var expandedPostIds: Set<Int> = []

    func fetchPosts() async throws {
        posts = try await networkService.fetchPosts()
    }

    func isExpanded(postId: Int) -> Bool {
        expandedPostIds.contains(postId)
    }

    func toggleExpand(postId: Int) {
        if expandedPostIds.contains(postId) {
            expandedPostIds.remove(postId)
        } else {
            expandedPostIds.insert(postId)
        }
    }
}
