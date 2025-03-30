//
//  BookReaderView.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//
import SwiftUI

// BookReaderView.swift
struct BookReaderView: View {
    let book: Book
    let quizAmount: Int
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: BookReaderViewModel
    
    init(book: Book, quizAmount: Int) {
        self.book = book
        self.quizAmount = quizAmount
        _viewModel = StateObject(wrappedValue: BookReaderViewModel(
            book: book,
            quizAmount: quizAmount
        ))
    }
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                navigationBar
                bookContent
                pageControls
                
            }
            
            settingsOverlays
            if viewModel.currentQuiz != nil {
                            Color.black.opacity(0.8)
                                .edgesIgnoringSafeArea(.all)
                                .transition(.opacity)
                        }
        }.fullScreenCover(item: $viewModel.currentQuiz) { quiz in
            NavigationView {
                EasyQuizView(
                    questionType: quiz.questionType,
                    question: quiz.question,
                    options: quiz.options
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") {
                            viewModel.currentQuiz = nil
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.currentPage) { newPage in
            if viewModel.quizPositions.contains(newPage) {
                viewModel.showQuiz(for: newPage)
            }
        }
    }
    
    private var readerContent: some View {
        VStack(spacing: 0) {
            navigationBar
            bookContent
            pageControls
        }
        .background(viewModel.selectedTheme.background)
    }
    
    
    private var navigationBar: some View {
        HStack {
            Button("Back") { dismiss() }
            Spacer()
            Text(book.title)
            Spacer()
            settingsButton
        }
        .padding()
        .background(Material.bar)
    }
    
    private var settingsButton: some View {
        Button(action: { viewModel.showSettings.toggle() }) {
            Image(systemName: "textformat")
                .padding(8)
                .background(Circle().fill(Color(.systemGray5)))
        }
    }
    
    
    
    private var pageControls: some View {
        HStack {
            PageControlButton(
                icon: "chevron.left",
                action: viewModel.previousPage,
                disabled: viewModel.currentPage == 0
            )
            
            Text("\(viewModel.currentPage + 1)/\(viewModel.paragraphs.count)")
                .font(.subheadline)
            
            PageControlButton(
                icon: "chevron.right",
                action: viewModel.nextPage,
                disabled: viewModel.currentPage == viewModel.paragraphs.count - 1
            )
        }
        .padding()
    }
    
    @ViewBuilder
    private var settingsOverlays: some View {
        if viewModel.showSettings {
            SettingsPanel(
                fontSize: $viewModel.fontSize,
                fontType: $viewModel.fontType,
                lineSpacing: $viewModel.lineSpacing,
                selectedTheme: $viewModel.selectedTheme,
                showThemes: $viewModel.showThemes, // Binding correcto
                dismiss: { viewModel.showSettings = false }
            )
        }
        
        if viewModel.showThemes {
            ThemesPanel(
                selectedTheme: $viewModel.selectedTheme,
                dismiss: { viewModel.showThemes = false }
            )
        }
    }
    
    @ViewBuilder
    
    
    private var bookContent: some View {
        GeometryReader { geometry in
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.paragraphs.count, id: \.self) { index in
                    ScrollView {
                        Text(viewModel.paragraphs[index])
                            .readerContentStyle(viewModel: viewModel)
                    }
                    .tag(index)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    viewModel.goToNextPage()
                                } else if value.translation.width > 100 {
                                    viewModel.goToPreviousPage()
                                }
                            }
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: viewModel.currentPage) { _ in
                viewModel.checkForQuiz()
            }
        }
    }
}
