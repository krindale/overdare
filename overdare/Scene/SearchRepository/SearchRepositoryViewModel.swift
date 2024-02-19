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
            print("total count : \(searchRepositoryResult?.totalCount ?? 0)")
            print("incomplete : \(searchRepositoryResult?.incompleteResults ?? false)")
            print("item count : \(searchRepositoryResult?.items.count ?? 0)")
            print("current Page: \(currentPage)")
        }
    }

    @Published var searchText: String = ""

    private var currentPage = 0
    private var nowLoadingNextPage = false
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var isShowErrorPopup = false
    var errorMessage = ""
    
    init() {
        self.$searchText
            .debounce(for: .seconds(0.15), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink { searchText in
                Task { [ weak self] in
                    if searchText.isEmpty {
                        await MainActor.run { [weak self] in
                            self?.searchRepositoryResult = nil
                        }
                    } else {
                        await self?.fetchRepositry(with: searchText)
                    }
                    self?.self.nowLoadingNextPage = false
                    self?.currentPage = 0
                }
            }.store(in: &cancellables)
    }
    
    
    private var canLoadMorePages: Bool {
        if let incompleteResults = self.searchRepositoryResult?.incompleteResults,
           incompleteResults == true || self.nowLoadingNextPage == true {
            return false
        }
        return true
    }
    
    func fetchNextPage() async {
        guard self.canLoadMorePages else { return }
        self.nowLoadingNextPage = true
        defer { self.nowLoadingNextPage = false }
        self.currentPage += 1
        await self.fetchRepositry(with: self.searchText, page: self.currentPage)

    }
    
    func fetchRepositry(with searchText: String, page: Int = 0) async {
        do {
            let searchRepositoryResult = try await FetchDataManager.shared.fetchGithubSearch(with: searchText, page: page)
            
            Task {
                await MainActor.run { [weak self] in
                    if let newValue = searchRepositoryResult {
                        self?.updateSearchResult(with: newValue, page: page)
                    } else {
                        self?.searchRepositoryResult = nil
                    }
                }
            }
        } catch let error as NSError {
            print(error)
            self.isShowErrorPopup = true
            self.errorMessage = error.domain
        } catch {
            print(error)
            self.isShowErrorPopup = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    private func updateSearchResult(with newValue: GitHubSearchResponse, page: Int) {
        if page == 0 {
            self.searchRepositoryResult = newValue
        } else {
            self.searchRepositoryResult?.totalCount = newValue.totalCount
            self.searchRepositoryResult?.incompleteResults = newValue.incompleteResults
            let newItems = newValue.items.filter { newItem in
                !(self.searchRepositoryResult?.items.contains(where: {
                    $0.id == newItem.id
                }) ?? false)
            }
            self.searchRepositoryResult?.items.append(contentsOf: newItems)
        }
    }
}
