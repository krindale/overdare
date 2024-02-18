//
//  RepotitoryDetailResponseModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

struct GitHubDetailResponse: Codable, Identifiable {
    let id: Int
    let fullName: String
    let description: String?
    let owner: User
    let forksCount: Int
    let stargazersCount: Int
    let subscribersCount: Int
}
