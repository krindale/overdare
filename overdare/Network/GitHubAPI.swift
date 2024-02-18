//
//  GitHubAPI.swift
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

enum GitHubAPI {
    // https://api.github.com/search/repositories?q={serchText}
    case searchRepotitory(searchText: String)
    
    // https://api.github.com/repos/{owner}/{repo}
    case fetchDetail(owner: String, repo: String)
}

extension GitHubAPI : APIProtocol {
    
    var baseURL: URL {
        guard let baseURL: URL = .init(string: "https://api.github.com") else {
            fatalError("Base URL Error !!!!")
        }
        
        return baseURL
    }
    
    var path: String {
        switch self {
        case .searchRepotitory:
            return "/search/repositories"
            
        case let .fetchDetail(owner, repo):
            return "/repos/\(owner)/\(repo)"
        }
    }
    
    var header: [String: String] {
        return [:]
    }
    
    var method: String {
        return "GET"
    }
    
    var query: [String : String] {
        switch self {
        case let .searchRepotitory(searchText):
            return ["q": searchText]
        default:
            return [:]
        }
    }
    
}
