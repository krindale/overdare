//
//  SearchRepositoryView.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import SwiftUI
import UIComponent
import APIManager

struct SearchRepositoryView: View {
    
    @ObservedObject var viewModel: SearchRepositoryViewModel
    
    var body: some View {
        NavigationStack() {
            List(viewModel.searchRepositoryResult?.items ?? []) { repo in
                NavigationLink(value: repo) {
                    LazyVStack(alignment: .leading) {
                        Text(repo.fullName).font(.headline)
                        LazyHStack {
                            Text(repo.description ?? "No description")
                                .font(.subheadline)
                                .lineLimit(1)
                            Text("By")
                            Text(repo.owner.login)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        LazyHStack {
                            TagView(type: .fork(count: repo.forksCount))
                            TagView(type: .star(count: repo.stargazersCount))
                        }.font(.caption)
                    }
                }.listRowBackground(GeometryReader { proxy in
                    Color.clear.onAppear {
                        if proxy.frame(in: .global).maxY < UIScreen.main.bounds.size.height + 100 {
                            Task {
                                await viewModel.fetchNextPage()
                            }
                        }
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle("Repository")
            .searchable( // <-
                text: $viewModel.searchText,
                placement: .automatic,
                prompt: "Repository Search"
            )
            .navigationDestination(for: Repository.self) { repo in
                RepositoryDetailView(viewModel: .init(owner: repo.owner.login, repo: repo.name))
            }
            .alert(isPresented: $viewModel.isShowErrorPopup) {
                Alert(
                    title: Text("Alert"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
}

#Preview {
    SearchRepositoryView(viewModel: .init())
}
