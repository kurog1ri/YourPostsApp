//
//  NetworkService.swift
//  YourPostsApp
//

import Foundation

final class NetworkService {

    private let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"

    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)/main.json") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PostsResponse.self, from: data)

        return response.posts
    }

    func fetchPostDetail(id: Int) async throws -> PostDetail {
        guard let url = URL(string: "\(baseURL)/posts/\(id).json") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PostDetailResponse.self, from: data)

        return response.post
    }
}

enum NetworkError: Error {
    case invalidURL
}
