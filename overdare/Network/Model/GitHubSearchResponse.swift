//
//  RepositoryResponseModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

struct GitHubSearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
    let description: String?
    let stargazersCount : Int
    let forksCount: Int
}

struct User: Codable {
    let login: String
    let id: Int
}
