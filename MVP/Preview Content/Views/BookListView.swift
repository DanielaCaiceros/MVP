//
//  BookListView.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import SwiftUI
import Kingfisher

struct BookListView: View {
    @StateObject private var viewModel = BookViewModel()
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var selectedBook: Book? = nil
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                mainHomeView
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)
                
                fullCatalogView
                    .tabItem { Label("Library", systemImage: "books.vertical.fill") }
                    .tag(1)
                
                AccountView()
                    .tabItem { Label("Account", systemImage: "person.fill") }
                    .tag(2)
            }
            .accentColor(.blue)
            .navigationDestination(item: $selectedBook) { book in
                BookDetailView(book: book)
            }
        }
    }
    
    private var mainHomeView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.error != nil {
                ErrorView(error: viewModel.error!)
            } else {
                contentView
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            header
            searchBar
            ScrollView {
                booksSections
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Home")
                .font(.largeTitle).bold()
            Spacer()
            userStatus
        }
        .padding()
    }
    
    private var userStatus: some View {
        HStack(spacing: 4) {
            Text("🔥6")
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    private var searchBar: some View {
        SearchBar(text: $searchText, onCommit: {
            viewModel.fetchBooks(searchQuery: searchText)
        })
    }
    
    private var booksSections: some View {
        VStack(alignment: .leading, spacing: 24) {
            bookSection(title: "Continue Reading", books: viewModel.continueReading)
            bookSection(title: "Want to Read", books: viewModel.wantToRead)
        }
        .padding()
    }
    
    private var fullCatalogView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                ForEach(viewModel.books) { book in
                    BookCard(book: book) {
                        selectedBook = book
                    }
                }
            }
            .padding()
        }
    }
    
    private func bookSection(title: String, books: [Book]) -> some View {
        VStack(alignment: .leading) {
            SectionHeader(title: title)
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(books) { book in
                        BookCard(book: book) {
                            selectedBook = book
                        }
                    }
                }
            }
        }
    }
}

struct BookCard: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                BookCover(imageURL: BookViewModel().coverImageURL(for: book))
                Text(book.title)
                    .font(.headline)
                Text(BookViewModel().authorName(for: book))
                    .font(.caption)
            }
            .frame(width: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onCommit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Find a book", text: $text, onCommit: onCommit)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
            Text("Error loading books")
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    BookListView()
        .environmentObject(BookViewModel())
}
