//
//  SearchRepositoryViewModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

final class SearchRepositoryViewModel: ObservableObject {
    @Published var searchRepositoryResult: GitHubSearchResponse?
    
    func fetchRepositry(searchText: String) async {
        do {
            let searchRepositoryResult = try await APIManager.shared.fetchGithubSearch(with: searchText)
            
            Task {
                await MainActor.run {
                    self.searchRepositoryResult = searchRepositoryResult
                }
            }
        } catch {
            print(error)
        }
    }
}
