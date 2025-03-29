import SwiftData
import Foundation

@MainActor
class AnalyticsViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    @Published var quizzes: [QuizItem] = []
    @Published var responses: [ResponseItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Computed Properties
    var averageScore: Double {
        guard !quizzes.isEmpty else { return 0 }
        return quizzes.map { $0.score }.reduce(0, +) / Double(quizzes.count)
    }
    
    var correctAnswerCount: Int {
        responses.filter { $0.answer == 1 }.count
    }
    
    var incorrectAnswerCount: Int {
        responses.count - correctAnswerCount
    }
    
    var totalWordsRead: Int {
        quizzes.map { $0.numWords }.reduce(0, +)
    }
    
    var totalTimeMinutes: Double {
        Double(quizzes.map { $0.time }.reduce(0, +)) / 60
    }
    
    // MARK: - Data Methods
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            quizzes = try modelContext.fetch(FetchDescriptor<QuizItem>())
            responses = try modelContext.fetch(FetchDescriptor<ResponseItem>())
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Analytics Methods
    func questionTypePerformance() -> [(type: String, percentCorrect: Double)] {
        let grouped = Dictionary(grouping: responses, by: { $0.typeQuestion })
        return grouped.map { key, values in
            let correct = values.filter { $0.answer == 1 }.count
            let percent = (Double(correct) / Double(values.count)) * 100
            return (key, percent)
        }.sorted { $0.type < $1.type }
    }
    
    func categoryPerformance() -> [(category: String, averageScore: Double)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let avg = values.map { $0.score }.reduce(0, +) / Double(values.count)
            return (key, avg)
        }.sorted { $0.category < $1.category }
    }
    
    func wordsByCategory() -> [(category: String, count: Int)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let count = values.map { $0.numWords }.reduce(0, +)
            return (key, count)
        }.sorted { $0.category < $1.category }
    }
    
    func timeByCategory() -> [(category: String, minutes: Double)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let seconds = values.map { $0.time }.reduce(0, +)
            return (key, Double(seconds) / 60)
        }.sorted { $0.category < $1.category }
    }
    
    func sortedQuizzesByDate() -> [QuizItem] {
        quizzes.sorted { $0.quizDate < $1.quizDate }
    }
}
