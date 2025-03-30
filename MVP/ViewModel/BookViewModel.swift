//
//  BookViewModel.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//
import SwiftUI

import Foundation
import SwiftUI

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var continueReading: [Book] = []
    @Published var wantToRead: [Book] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        fetchBooks()
    }
    
    func fetchBooks(searchQuery: String? = nil) {
        isLoading = true
        NetworkManager.shared.fetchBooks(searchQuery: searchQuery) { [weak self] books in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let books = books {
                    self?.books = books
                    self?.continueReading = Array(books.prefix(3)) // Últimos 3 libros leídos
                    self?.wantToRead = Array(books.suffix(3)) // Próximos 3 libros a leer
                }
            }
        }
    }
    
    func authorName(for book: Book) -> String {
        book.authors?.first?.name ?? "Autor desconocido"
    }
    
    func coverImageURL(for book: Book) -> URL? {
        guard let formats = book.formats else { return nil }
        
        let imageKeys = [
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/gif"
        ]
        
        for key in imageKeys {
            if let urlString = formats[key], let url = URL(string: urlString) {
                return url
            }
        }
        
        return nil
    }
}

