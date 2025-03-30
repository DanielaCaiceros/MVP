//
//  BookDetailView.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

import SwiftUICore
import Foundation
import SwiftUI


struct BookDetailView: View {
    let book: Book
    @State private var showReader = false
    @State private var selectedQuizAmount = 5
    @State private var startReading = false // Nuevo estado
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                BookCover(imageURL: BookViewModel().coverImageURL(for: book))
                    .frame(height: 300)
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.largeTitle.bold())
                    Text(BookViewModel().authorName(for: book))
                        .font(.title2)
                }
                
                BookMetadata(book: book)
                
                if book.textFileURL != nil {
                    Button("Read Now") {
                        showReader = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .fullScreenCover(isPresented: $showReader) {
                QuizAmountSelectorView(quizAmount: $selectedQuizAmount) {
                    startReading = true // Actualiza el estado aquí
                }
            }
            .fullScreenCover(isPresented: $startReading) {
                BookReaderView(book: book, quizAmount: selectedQuizAmount)
            }
        }
    }
    
    
    
    
    struct BookMetadata: View {
        let book: Book
        
        var body: some View {
            VStack(alignment: .leading) {
                if let languages = book.languages {
                    MetadataRow(icon: "globe", text: languages.joined(separator: ", "))
                }
                
                if let downloads = book.downloadCount {
                    MetadataRow(icon: "arrow.down.circle", text: "\(downloads) downloads")
                }
            }
        }
    }
    
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}
