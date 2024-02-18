//
//  SearchRepositoryView.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import SwiftUI

struct SearchRepositoryView: View {
    
    @ObservedObject var viewModel: SearchRepositoryViewModel
    
    var body: some View {
        NavigationStack() {
            VStack {
                List(viewModel.searchRepositoryResult?.items ?? []) { repo in
                    NavigationLink(value: repo) {
                        VStack(alignment: .leading) {
                            Text(repo.fullName).font(.headline)
                            HStack {
                                Text(repo.description ?? "No description")
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Text("By")
                                Text(repo.owner.login)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            HStack {
                                TagView(type: .fork(count: repo.forksCount))
                                TagView(type: .star(count: repo.stargazersCount))
                            }.font(.caption)
                        }
                    }
                }.listStyle(.plain)
                .navigationTitle("Repository")
                .searchable( // <-
                  text: $viewModel.searchText,
                  placement: .automatic,
                  prompt: "Repository Search"
                )
                .navigationDestination(for: Repository.self) { repo in
                    RepositoryDetailView(viewModel: .init(owner: repo.owner.login, repo: repo.name))
                }
            }
        }
     }
}

#Preview {
    SearchRepositoryView(viewModel: .init())
}
