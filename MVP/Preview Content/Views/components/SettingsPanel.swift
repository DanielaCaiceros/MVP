//
//  SettingsPanel.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

import SwiftUICore
import SwiftUI


// Agrega este archivo como SettingsPanel.swift
struct SettingsPanel: View {
    @Binding var fontSize: Double
        @Binding var fontType: BookReaderViewModel.FontType
        @Binding var lineSpacing: Double
        @Binding var selectedTheme: BookReaderViewModel.Theme
        @Binding var showThemes: Bool
        let dismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Ajustes de lectura")
                    .font(.headline)
                
                HStack {
                    Text("Tamaño:")
                    Slider(value: $fontSize, in: 12...28, step: 1)
                    Text("\(Int(fontSize))")
                        .frame(width: 30)
                }
                
                Picker("Fuente:", selection: $fontType) {
                    ForEach(BookReaderViewModel.FontType.allCases, id: \.self) { font in
                        Text(font.rawValue).tag(font)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Text("Espaciado:")
                    Slider(value: $lineSpacing, in: 1...3, step: 0.1)
                    Text(String(format: "%.1f", lineSpacing))
                        .frame(width: 30)
                }
                
                Button(action: {
                                    showThemes = true // Usar el binding
                                }) {
                                    HStack {
                                        Image(systemName: "paintpalette")
                                        Text("Cambiar tema")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                
                Button("Listo", action: dismiss)
                    .buttonStyle(.borderedProminent)
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
