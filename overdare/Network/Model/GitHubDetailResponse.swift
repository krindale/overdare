//
//  RepotitoryDetailResponseModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

struct GitHubDetailResponse: Codable {
    let id: Int
    let fullName: String
    let description: String?
    let owner: Owner
    let forksCount: Int
    let stargazersCount: Int
    let subscribersCount: Int
}

struct Owner: Codable {
    let login: String
}
