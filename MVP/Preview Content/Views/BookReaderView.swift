//
//  BookReaderView.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import SwiftUI

struct BookReaderView: View {
    let book: Book
    @State private var bookContent: String = "Cargando..."
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage = 0
    @State private var pages: [String] = []
    
    var body: some View {
        VStack {
            // Barra de navegación personalizada
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                .padding(.leading)
                
                Text(book.title)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            
            // Contenido del libro con paginación
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    ScrollView {
                        Text(pages[index])
                            .padding()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Controles de página
            HStack {
                Button(action: {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                Text("Página \(currentPage + 1) de \(pages.count)")
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                }
                .disabled(currentPage == pages.count - 1)
            }
            .padding()
        }
        .task {
            await loadBookContent()
        }
    }
    
    private func loadBookContent() async {
        guard let url = book.textFileURL else {
            bookContent = "Formato no disponible"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fullText = String(data: data, encoding: .utf8) ?? ""
            pages = splitTextIntoPages(text: fullText)
        } catch {
            pages = ["Error al cargar el libro: \(error.localizedDescription)"]
        }
    }
    
    private func splitTextIntoPages(text: String, wordsPerPage: Int = 300) -> [String] {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        return stride(from: 0, to: words.count, by: wordsPerPage).map {
            Array(words[$0..<min($0 + wordsPerPage, words.count)]).joined(separator: " ")
        }
    }
}
