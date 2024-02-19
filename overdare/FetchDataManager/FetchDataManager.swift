//
//  FetchDataManager.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

protocol APIProtocol {
    var baseURL: URL { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: String { get }
    var query: [String: String] { get }
}

final actor FetchDataManager {
    
    static let shared: FetchDataManager = .init()
    
    private let apiManager: APIManager = .shared
    private let cacheManager: CacheManager = .shared
    
    private init() {}
    
    func fetchGithubSearch(with searchtext: String, page: Int) async throws -> GitHubSearchResponse? {
        let data = try await fetchData(api: GitHubAPI.searchRepotitory(searchText: searchtext, page: page))
        return try data.decode(GitHubSearchResponse.self)
    }
    
    func fetchGithubDetail(with owner: String, repo: String) async throws -> GitHubDetailResponse? {
        let data = try await fetchData(api: GitHubAPI.fetchDetail(owner: owner, repo: repo))
        return try data.decode(GitHubDetailResponse.self)
    }
}

extension FetchDataManager {
    private func fetchData<T: APIProtocol>(api: T) async throws -> Data {
        let request = try URLRequest.create(from: api)

        if let data = await cacheManager.loadFromCache(for: request) {
            return data
        } else {
            let (data, response) = try await self.apiManager.request(with: request)
            await cacheManager.storeToCache(data: data, response: response, for: request)
            return data
        }
    }
}
