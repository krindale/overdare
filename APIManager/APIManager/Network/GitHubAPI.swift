//
//  GitHubAPI.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

public protocol APIProtocol {
    var baseURL: URL { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: String { get }
    var query: [String: String] { get }
}

public enum GitHubAPI {
    // https://api.github.com/search/repositories?q={serchText}
    // &page=2&per_page=50
    case searchRepotitory(searchText: String, page: Int, per_page: Int = 50)
    
    // https://api.github.com/repos/{owner}/{repo}
    case fetchDetail(owner: String, repo: String)
}

extension GitHubAPI : APIProtocol {
    
    public var baseURL: URL {
        guard let baseURL: URL = .init(string: "https://api.github.com") else {
            fatalError("Base URL Error !!!!")
        }
        
        return baseURL
    }
    
    public var path: String {
        switch self {
        case .searchRepotitory:
            return "/search/repositories"
            
        case let .fetchDetail(owner, repo):
            return "/repos/\(owner)/\(repo)"
        }
    }
    
    public var header: [String: String] {
        var header: [String: String] = [:]
        header["Accept"] = "application/vnd.github+json"
        header["X-GitHub-Api-Version"] = "2022-11-28"
        header["Authorization"] = "token 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"
        return header
    }
    
    public var method: String {
        return "GET"
    }

    public var query: [String : String] {
        switch self {
        case let .searchRepotitory(searchText, page, per_page):
            return ["q": searchText, "page" :"\(page)", "per_page": "\(per_page)"]
        default:
            return [:]
        }
    }
    
}
