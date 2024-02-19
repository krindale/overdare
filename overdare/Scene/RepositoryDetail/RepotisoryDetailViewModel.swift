//
//  RepotisoryDetailViewModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation
import APIManager

final class RepositoryDetailViewModel: ObservableObject {
    @Published var repositoryDetailResponse: GitHubDetailResponse?
    
    var owner: String
    var repo: String

    init(owner: String, repo: String) {
        self.owner = owner
        self.repo = repo
    }
    
    func fetchRepositoryDetail() async throws {
        try await self.fetchRepositoryDetail(with: self.owner, repo: self.repo)
    }

    func fetchRepositoryDetail(with owner: String, repo: String) async throws {
        let repositoryDetail = try await FetchDataManager.shared.fetchGithubDetail(with: owner, repo: repo)
        
        Task {
            await MainActor.run {
                self.repositoryDetailResponse = repositoryDetail
            }
        }
    }
}
