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
    
    var body: some View {
        ScrollView {
            Text(bookContent)
                .padding()
        }
        .navigationTitle(book.title)
        .task {
            book.printAvailableFormats()
            await loadBookContent()
        }
    }
    
    private func loadBookContent() async {
        guard let url = book.textFileURL else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica el código de respuesta HTTP (debe ser 200)
            if let httpResponse = response as? HTTPURLResponse {
                print("🛠️ Status Code: \(httpResponse.statusCode)")
                print("🛠️ Headers: \(httpResponse.allHeaderFields)")
            }
            
            if let text = String(data: data, encoding: .utf8) {
                bookContent = String(text.prefix(10000)) // Limita para pruebas
            } else {
                bookContent = "Error al decodificar (formato no UTF-8)"
            }
        } catch {
            print("⛔ Error de descarga: \(error.localizedDescription)")
            bookContent = "Error: \(error.localizedDescription)"
        }
    }
}
