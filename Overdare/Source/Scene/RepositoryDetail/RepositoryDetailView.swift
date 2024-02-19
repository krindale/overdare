//
//  RepositoryDetailView.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import SwiftUI
import UIComponent

struct RepositoryDetailView: View {
    @ObservedObject var viewModel: RepositoryDetailViewModel
    
    var body: some View {
        Group {
            if let detailInfo = viewModel.repositoryDetailResponse {
                VStack(alignment: .leading) {
                    Text(detailInfo.description ?? "No description")
                    Text("By \(detailInfo.owner.login)")
                    
                    HStack {
                        TagView(type: .fork(count: detailInfo.forksCount))
                        TagView(type: .star(count: detailInfo.stargazersCount))
                        TagView(type: .subscribe(count: detailInfo.subscribersCount))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding()
            } else {
                Text("No Data !")
                    .font(.title)
            }
        }.navigationTitle(viewModel.repositoryDetailResponse?.fullName ?? "-")
        .task {
            do {
                try await viewModel.fetchRepositoryDetail()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    RepositoryDetailView(viewModel: .init(owner: "hello", repo: "helloWorld"))
}
