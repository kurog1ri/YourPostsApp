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

        let (data, response) = try await performRequest(url: url)
        try validateResponse(response)

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            let decoded = try JSONDecoder().decode(PostsResponse.self, from: data)
            return decoded.posts
        } catch {
            throw NetworkError.decodingError
        }
    }

    func fetchPostDetail(id: Int) async throws -> PostDetail {
        guard let url = URL(string: "\(baseURL)/posts/\(id).json") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await performRequest(url: url)
        try validateResponse(response)

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            let decoded = try JSONDecoder().decode(PostDetailResponse.self, from: data)
            return decoded.post
        } catch {
            throw NetworkError.decodingError
        }
    }

    private func performRequest(url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(from: url)
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternetConnection
            }
            throw error
        }
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
}

// MARK: - NetworkError

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case noInternetConnection

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to process server response"
        case .serverError(let code):
            return "Server error (code: \(code))"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
