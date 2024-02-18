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
    
    func fetchGithubDetail(with owner: String, repo: String) async throws -> GitHubSearchResponse? {
        let data = try await request(api: GitHubAPI.fetchDetail(owner: owner, repo: repo))
        return try data.decode(GitHubSearchResponse.self)
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

        let (data, _) = try await URLSession.shared.data(for: request)
#if DEBUG
        print(data.prettyPrintedJSONString)
#endif
        return data
    }
}
