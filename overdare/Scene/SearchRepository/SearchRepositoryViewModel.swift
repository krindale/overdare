//
//  SearchRepositoryViewModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation
import Combine

final class SearchRepositoryViewModel: ObservableObject {
    @Published var searchRepositoryResult: GitHubSearchResponse?
    @Published var searchText: String = ""
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        self.$searchText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.global())
            .sink { searchText in
                Task { [ weak self] in
                    if searchText.isEmpty {
                        await MainActor.run { [weak self] in
                            self?.searchRepositoryResult = nil
                        }
                    } else {
                        await self?.fetchRepositry(with: searchText)
                    }
                }
            }.store(in: &cancellables)
    }
    
    func fetchRepositry(with searchText: String) async {
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
