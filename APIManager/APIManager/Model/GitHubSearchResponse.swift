//
//  RepositoryResponseModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

public struct GitHubSearchResponse: Codable {
    public var totalCount: Int
    public var incompleteResults: Bool
    public var items: [Repository]
}

public struct Repository: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: User
    public let description: String?
    public let stargazersCount : Int
    public let forksCount: Int
}

public struct User: Codable, Hashable {
    public let login: String
    public let id: Int
}
