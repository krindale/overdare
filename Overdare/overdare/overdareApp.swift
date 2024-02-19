//
//  overdareApp.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import SwiftUI

@main
struct overdareApp: App {
    var body: some Scene {
        WindowGroup {
            SearchRepositoryView(viewModel: .init())
        }
    }
}
