//
//  BookListView.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                NavigationLink(destination: BookReaderView(book: book)) {
                    VStack(alignment: .leading) {
                        Text(book.title).font(.headline)
                        Text(book.authors?.first?.name ?? "Autor desconocido").font(.subheadline)
                        Text("Descargas: \(book.downloadCount ?? 0)").font(.caption)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Buscar libros...")
            .onSubmit(of: .search) {
                viewModel.searchBooks(query: searchText)
            }
            .navigationTitle("Catálogo")
            .task {
                viewModel.fetchBooks()
            }
        }
    }
}

#Preview {
    BookListView()
}
