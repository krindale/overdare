//
//  APIManager.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

final class APIManager {

    static let shared: APIManager = .init()
    private init() {}
    
    func fetchGithubSearch(with searchtext: String) async throws -> GitHubSearchResponse? {
        let data = try await request(api: GitHubAPI.searchRepotitory(searchText: searchtext))
        return try data.decode(GitHubSearchResponse.self)
    }
    
    func fetchGithubDetail(with owner: String, repo: String) async throws -> GitHubDetailResponse? {
        let data = try await request(api: GitHubAPI.fetchDetail(owner: owner, repo: repo))
        return try data.decode(GitHubDetailResponse.self)
    }
}

extension APIManager {
    private func request<T: APIProtocol>(api: T) async throws -> Data {
        var components = URLComponents(url: api.baseURL.appendingPathComponent(api.path), resolvingAgainstBaseURL: false)
        components?.queryItems = api.query.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = api.method
        request.allHTTPHeaderFields = api.header
#if DEBUG
    print("\n--- Request Start ---")
    print("URL: \(url.absoluteString)")
    print("Method: \(api.method)")
    if let headers = request.allHTTPHeaderFields {
        print("Headers: \(headers)")
    }
    print("--- Request End ---\n")
#endif
        let (data, response) = try await URLSession.shared.data(for: request)
#if DEBUG
    if let httpResponse = response as? HTTPURLResponse {
        print("\n--- Response Start ---")
        print("Status Code: \(httpResponse.statusCode)")
        print("Response: \(data.prettyPrintedJSONString)")
        print("--- Response End ---\n")
    }
#endif
        return data
    }
}
