//
//  Post.swift
//  YourPostsApp
//

import Foundation

// MARK: - Feed Response

struct PostsResponse: Codable {
    let posts: [Post]
}

struct Post: Codable, Sendable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

extension Post: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(postId)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.postId == rhs.postId
    }
}

// MARK: - Detail Response

struct PostDetailResponse: Codable {
    let post: PostDetail
}

struct PostDetail: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case text
        case postImage
        case likesCount = "likes_count"
    }
}
