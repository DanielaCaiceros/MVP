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
    private var searchWorkItem: DispatchWorkItem?
    @Published var books: [Book] = []
    @Published var continueReading: [Book] = []
    @Published var wantToRead: [Book] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
            fetchBooks()
            loadFavorites()
        }
    
    func fetchBooks(searchQuery: String? = nil) {
            isLoading = true
            NetworkManager.shared.fetchBooks(searchQuery: searchQuery) { [weak self] books in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let books = books {
                        self?.books = books
                        self?.continueReading = Array(books.prefix(6))
                        self?.loadFavorites() // Reload favorites after fetching books
                    }
                }
            }
        }
    func loadFavorites() {
            let favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
            wantToRead = books.filter { favorites.contains($0.id) }
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
    
    
    
    func searchBooks(query: String) {
            // Cancel previous request if it exists
            searchWorkItem?.cancel()
            
            // Create new work item
            let workItem = DispatchWorkItem { [weak self] in
                self?.fetchBooks(searchQuery: query)
            }
            
            // Schedule after 0.5 second delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
            searchWorkItem = workItem
    }
    
    func toggleFavorite(book: Book) {
            var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
            
            if favorites.contains(book.id) {
                favorites.removeAll { $0 == book.id }
            } else {
                favorites.append(book.id)
            }
            
            UserDefaults.standard.set(favorites, forKey: "favorites")
            loadFavorites() // Update wantToRead after toggling
        }

}

