//
//  BookViewModel.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//
import SwiftUI

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    
    func fetchBooks() {
        NetworkManager.shared.fetchBooks { [weak self] fetchedBooks in
            DispatchQueue.main.async {
                self?.books = fetchedBooks ?? []
            }
        }
    }
    
    func searchBooks(query: String) {
        NetworkManager.shared.fetchBooks(searchQuery: query) { [weak self] fetchedBooks in
            DispatchQueue.main.async {
                self?.books = fetchedBooks ?? []
            }
        }
    }
}


