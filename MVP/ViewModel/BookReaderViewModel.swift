//
//  BookReaderViewModel.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//


// BookReaderViewModel.swift
import SwiftUI
import Combine

@MainActor
class BookReaderViewModel: ObservableObject {
    @Published var showThemes = false // Asegúrate que esta propiedad existe
    @Published var padding: Double = 20 
    @Published var paragraphs: [String] = []
    @Published var currentPage = 0
    @Published var showSettings = false
    @Published var showQuiz = false
    @Published var quizPositions: [Int] = []
    @Published var currentQuizPage: Int? = nil
    
    // Configuración
    @Published var fontSize: Double = 18
    @Published var fontType: FontType = .system
    @Published var lineSpacing: Double = 1.5
    @Published var selectedTheme: Theme = .light
    
    
    private let book: Book
    private let quizAmount: Int
    private var currentQuizIndex = 0
    
    init(book: Book, quizAmount: Int) {
        self.book = book
        self.quizAmount = quizAmount
        loadContent()
    }
    @Published var showSummary = false
        @Published var readingStats = ReadingStats()
        
        struct ReadingStats {
            var wordCount: Int = 0
            var startTime: Date?
            var minutes: Int = 0
            var seconds: Int = 0
        }
        
        func startReadingSession() {
            readingStats.startTime = Date()
        }
        
        func calculateReadingStats() {
            guard let startTime = readingStats.startTime else { return }
            
            let duration = Int(Date().timeIntervalSince(startTime))
            readingStats.minutes = duration / 60
            readingStats.seconds = duration % 60
            readingStats.wordCount = paragraphs.reduce(0) { $0 + $1.components(separatedBy: .whitespaces).count }
            
            showSummary = true
        }
    @Published var currentQuiz: QuizQuestion? = nil
        
        struct QuizQuestion: Identifiable {
            let id = UUID()
            let questionType: String
            let question: String
            let options: [Answer]
        }
        
        func showQuiz(for page: Int) {
            // Lógica para obtener las preguntas (por ahora datos de prueba)
            currentQuiz = QuizQuestion(
                questionType: "Vocabulary",
                question: "¿Qué significa 'Ephemeral'?",
                options: [
                    Answer(answerText: "Duradero", correct: false),
                    Answer(answerText: "Efímero", correct: true),
                    Answer(answerText: "Brillante", correct: false)
                ]
            )
        }
    
    func checkForQuiz() {
            if quizPositions.contains(currentPage) && !quizShownForCurrentPage {
                currentQuizPage = currentPage
                quizShownForCurrentPage = true
            }
        }
        
        private var quizShownForCurrentPage = false
        
        func resetQuizState() {
            quizShownForCurrentPage = false
        }
        
    private func calculateQuizPositions() {
        guard !paragraphs.isEmpty, quizAmount > 0 else {
            quizPositions = []
            return
        }
        
        let totalPages = paragraphs.count
        let pagesPerQuiz = max(1, Int(ceil(Double(totalPages) / Double(quizAmount))))
        
        quizPositions = (1...quizAmount).map { quizNumber in
            min(quizNumber * pagesPerQuiz, totalPages - 1)
        }
        
        print("🔢 Quiz positions calculated: \(quizPositions)")
    }
        
        func goToNextPage() {
            resetQuizState()
            currentPage = min(currentPage + 1, paragraphs.count - 1)
            checkForQuiz()
        }
        
        func goToPreviousPage() {
            resetQuizState()
            currentPage = max(currentPage - 1, 0)
            checkForQuiz()
        }
    
    func loadContent() {
        Task {
            guard let url = book.textFileURL else {
                paragraphs = ["Content not available"]
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let text = String(data: data, encoding: .utf8) ?? ""
                paragraphs = splitIntoPages(text: text)
                calculateQuizPositions()
            } catch {
                paragraphs = ["Error loading content"]
            }
        }
    }
    
    private var maxPageSize: Int = 1500 // Ajusta este valor según necesidades
        
        private func splitIntoPages(text: String) -> [String] {
            let normalizedText = text
                .replacingOccurrences(of: "\r\n", with: "\n")
                .replacingOccurrences(of: "\r", with: "\n")
            
            let rawParagraphs = normalizedText.components(separatedBy: "\n\n")
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            
            var processedPages: [String] = []
            var currentPageContent = ""
            
            for paragraph in rawParagraphs {
                let trimmedParagraph = paragraph.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedParagraph.count > maxPageSize {
                    let sentences = trimmedParagraph.components(separatedBy: ". ")
                    var currentSentenceGroup = ""
                    
                    for sentence in sentences {
                        let testContent = currentSentenceGroup.isEmpty ?
                            sentence :
                            currentSentenceGroup + ". " + sentence
                        
                        if testContent.count + currentPageContent.count < maxPageSize {
                            currentSentenceGroup = testContent
                        } else {
                            if !currentPageContent.isEmpty {
                                processedPages.append(currentPageContent)
                                currentPageContent = ""
                            }
                            processedPages.append(testContent)
                            currentSentenceGroup = ""
                        }
                    }
                    
                    if !currentSentenceGroup.isEmpty {
                        currentPageContent += currentSentenceGroup
                    }
                } else {
                    if currentPageContent.isEmpty {
                        currentPageContent = trimmedParagraph
                    } else if currentPageContent.count + trimmedParagraph.count + 2 < maxPageSize {
                        currentPageContent += "\n\n" + trimmedParagraph
                    } else {
                        processedPages.append(currentPageContent)
                        currentPageContent = trimmedParagraph
                    }
                }
            }
            
            if !currentPageContent.isEmpty {
                processedPages.append(currentPageContent)
            }
            
            return processedPages.isEmpty ? ["Contenido no disponible"] : processedPages
        }
        
    
    
    
    
    func continueReading() {
        currentQuizIndex += 1
    }
    
    func nextPage() {
        currentPage = min(currentPage + 1, paragraphs.count - 1)
        checkForQuiz()
    }
    
    func previousPage() {
        currentPage = max(currentPage - 1, 0)
    }
    
    // Enums de configuración
    enum FontType: String, CaseIterable {
        case system, serif, sansSerif, monospace
        
        var font: Font {
            switch self {
            case .system: return .body
            case .serif: return .custom("Georgia", size: 16)
            case .sansSerif: return .custom("Avenir", size: 16)
            case .monospace: return .custom("Courier New", size: 16)
            }
        }
    }
    
    enum Theme: String, CaseIterable {
        case light, dark, sepia
        
        var background: Color {
            switch self {
            case .light: return .white
            case .dark: return .black
            case .sepia: return Color(red: 0.95, green: 0.93, blue: 0.86)
            }
        }
        
        var textColor: Color {
            switch self {
            case .light: return .black
            case .dark: return .white
            case .sepia: return Color(red: 0.24, green: 0.21, blue: 0.16)
            }
        }
    }
}
