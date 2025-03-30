//
//  PageControlButton.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

import SwiftUICore
import SwiftUI


// View Components
extension View {
    func styledNavigationIcon() -> some View {
        self
            .font(.headline)
            .padding(8)
            .background(Color(.systemGray5))
            .clipShape(Circle())
    }
    
    func headlineTitle() -> some View {
        self
            .font(.headline)
            .lineLimit(1)
            .padding(.horizontal)
    }
    
    func navigationBarPadding() -> some View {
        self
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color(.systemBackground).opacity(0.9))
    }
}

struct PageControlButton: View {
    let icon: String
    let action: () -> Void
    let disabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .padding()
                .opacity(disabled ? 0.5 : 1)
        }
        .disabled(disabled)
    }
}

struct PageIndicator: View {
    let current: Int
    let total: Int
    let theme: BookReaderViewModel.Theme
    
    var body: some View {
        Text("\(current)/\(total)")
            .font(.subheadline)
            .monospacedDigit()
            .foregroundColor(theme.textColor)
    }
}
