//
//  TagView.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import SwiftUI


enum TagType {
    case star(count: Int)
    case fork(count: Int)
    case subscribe(count: Int)
    // Add more types as needed

    var backgroundColor: Color {
        switch self {
        case .star:
            return .blue
        case .fork:
            return .orange
        case .subscribe:
            return .pink
        }
    }

    var imageName: String {
        switch self {
        case .star:
            return "star"
        case .fork:
            return "arrow.triangle.merge"
        case .subscribe:
            return "eye"
        }
    }
    
    var text: String {
        switch self {
        case .star(let count), 
            .fork(let count),
            .subscribe(let count) :
            return "\(count)"
        }
    }
}


struct TagView: View {
    var type: TagType

    var body: some View {
        HStack(spacing: 3.0) {
            Image(systemName: type.imageName)
                .foregroundStyle(.white)
                .scaleEffect(x: -1, y: 1)
            Text(type.text)
                .foregroundStyle(.white)
        }
        .padding(7.0)
        .background(type.backgroundColor)
        .cornerRadius(7.0)
    }
}
#Preview {
    TagView(type: .star(count: 3425))
}
