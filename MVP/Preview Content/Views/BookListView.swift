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
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Home Tab
                mainHomeView
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // Library Tab
                fullCatalogView
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }
                    .tag(1)
                
                // Account Tab
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.fill")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    // MARK: - Home Tab Components
    private var mainHomeView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.error != nil {
                Text("Error loading books")
                    .foregroundColor(.red)
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
                VStack(alignment: .leading, spacing: 24) {
                    if !viewModel.continueReading.isEmpty {
                        bookSection(title: "Continue Reading", books: viewModel.continueReading)
                    }
                    if !viewModel.wantToRead.isEmpty {
                        bookSection(title: "Want to Read", books: viewModel.wantToRead)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Library Tab Components
    private var fullCatalogView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(viewModel.books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        bookCard(book)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    // MARK: - Shared Components
    private var header: some View {
        HStack {
            Text("Home")
                .font(.largeTitle).bold()
            Spacer()
            HStack(spacing: 4) {
                Text("🔥6")
                // Placeholder for user avatar
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Find a book", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(.webSearch)
                .onSubmit {
                    viewModel.fetchBooks(searchQuery: searchText)
                }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func bookSection(title: String, books: [Book]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2).bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(books) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            bookCard(book)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private func bookCard(_ book: Book) -> some View {
        VStack(alignment: .leading) {
            if let imageURL = viewModel.coverImageURL(for: book) {
                KFImage(imageURL)
                    .resizable()
                    .placeholder {
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 180)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .frame(width: 120, height: 180)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            
            Text(viewModel.authorName(for: book))
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.black)
        }
        .frame(width: 120)
    }
}

// MARK: - Book Detail View
struct BookDetailView: View {
    let book: Book
    @State private var showReader = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Cover Image
                if let imageURL = BookViewModel().coverImageURL(for: book) {
                    KFImage(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                
                // Title and Author
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.largeTitle.bold())
                    
                    Text(BookViewModel().authorName(for: book))
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                // Metadata
                VStack(alignment: .leading, spacing: 12) {
                    if let languages = book.languages, !languages.isEmpty {
                        metadataRow(icon: "globe", text: languages.joined(separator: ", "))
                    }
                    
                    if let downloadCount = book.downloadCount {
                        metadataRow(icon: "arrow.down.circle", text: "\(downloadCount) downloads")
                    }
                }
                .padding(.vertical)
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Add to favorites action
                    }) {
                        Label("Favorite", systemImage: "heart")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    
                    if book.textFileURL != nil {
                        Button(action: {
                            showReader = true
                        }) {
                            Label("Read Now", systemImage: "book")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.top)
                
                Divider()
                
                // Description placeholder
                Text("Description")
                    .font(.title2.bold())
                
                Text(bookDescription(for: book))
                    .font(.body)
                    .lineSpacing(6)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showReader) {
            if book.textFileURL != nil {
                BookReaderView(book: book)
            }
        }
    }
    
    private func metadataRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
    
    private func bookDescription(for book: Book) -> String {
        // Placeholder description - in a real app you might fetch this from an API
        return "This is a placeholder description for \(book.title). In a real application, this would be fetched from the book's metadata or from a summary service. The book \(book.title) by \(BookViewModel().authorName(for: book)) is a classic work available through Project Gutenberg."
    }
}

// MARK: - Supporting Views
struct AccountView: View {
    var body: some View {
        Text("Account View")
            .font(.largeTitle)
    }
}

#Preview {
    BookListView()
}
