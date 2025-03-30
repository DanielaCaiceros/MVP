//
//  ThemesPanel.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//
import SwiftUI

// Agrega este archivo como ThemesPanel.swift
struct ThemesPanel: View {
    @Binding var selectedTheme: BookReaderViewModel.Theme
    let dismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Seleccionar tema")
                    .font(.headline)
                    .padding(.top)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(BookReaderViewModel.Theme.allCases, id: \ .self) { theme in
                        Button(action: {
                            selectedTheme = theme
                            dismiss()
                        }) {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(theme.background)
                                    .frame(height: 80)
                                    .overlay(
                                        Text("Ejemplo")
                                            .foregroundColor(theme.textColor)
                                    )
                                Text(theme.rawValue.capitalized)
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                
                Button("Cancelar", action: dismiss)
                    .padding(.top)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .transition(.move(edge: .bottom))
    }
}
