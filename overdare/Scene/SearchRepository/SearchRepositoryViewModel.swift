//
//  SearchRepositoryViewModel.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation
import Combine

final class SearchRepositoryViewModel: ObservableObject {
    @Published var searchRepositoryResult: GitHubSearchResponse? {
        didSet {
            print("count : \(self.searchRepositoryResult?.totalCount ?? 0)")
            print("incompleteresult : \(self.searchRepositoryResult?.incompleteResults ?? false)")
            print("item : \((self.searchRepositoryResult?.items ?? []).map { $0.fullName } )")
            print("item count: \((self.searchRepositoryResult?.items ?? []).count )")
        }
    }
    @Published var searchText: String = ""
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        self.$searchText
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
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
            let searchRepositoryResult = try await FetchDataManager.shared.fetchGithubSearch(with: searchText)
            
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
