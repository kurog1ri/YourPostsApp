//
//  PostDetailViewModel.swift
//  YourPostsApp
//

import Foundation

final class PostDetailViewModel {

    private let networkService = NetworkService()
    private let postId: Int

    private(set) var postDetail: PostDetail?

    init(postId: Int) {
        self.postId = postId
    }

    func fetchPostDetail() async throws {
        postDetail = try await networkService.fetchPostDetail(id: postId)
    }

    var formattedDate: String {
        guard let timestamp = postDetail?.timeshamp else { return "" }

        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"

        return formatter.string(from: date)
    }

    var formattedLikes: String {
        guard let likes = postDetail?.likesCount else { return "" }
        return "❤️ \(likes)"
    }
}
