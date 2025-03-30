//
//  View+Extensions.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

// Agrega este archivo como View+Extensions.swift
import SwiftUI

extension View {
    func styledPageContent(font: Font, fontSize: Double, lineSpacing: Double, padding: Double, theme: BookReaderViewModel.Theme) -> some View {
        self
            .font(font)
            .foregroundColor(theme.textColor)
            .font(.system(size: fontSize))
            .lineSpacing(lineSpacing)
            .padding(padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(theme.background)
    }
    
    func gestureNavigation(onSwipeLeft: @escaping () -> Void, onSwipeRight: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation {
                            onSwipeLeft()
                        }
                    } else if value.translation.width > 100 {
                        withAnimation {
                            onSwipeRight()
                        }
                    }
                }
        )
    }
    
    func pageControlsPadding() -> some View {
        self
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(Color(.systemBackground).opacity(0.9))
    }
}

extension View {
    func swipeGesture(
        onSwipeLeft: @escaping () -> Void,
        onSwipeRight: @escaping () -> Void
    ) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -100 {
                        onSwipeLeft()
                    } else if value.translation.width > 100 {
                        onSwipeRight()
                    }
                }
        )
    }
}
