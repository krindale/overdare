//
//  RepotitoryDetailResponseModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

public struct GitHubDetailResponse: Codable, Identifiable {
    public let id: Int
    public let fullName: String
    public let description: String?
    public let owner: User
    public let forksCount: Int
    public let stargazersCount: Int
    public let subscribersCount: Int
}
