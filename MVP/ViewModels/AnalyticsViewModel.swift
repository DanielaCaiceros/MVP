import SwiftData
import Foundation

@MainActor
class AnalyticsViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    @Published var quizzes: [QuizItem] = []
    @Published var responses: [ResponseItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Propiedades diarias
    @Published var quizzesToday: Int = 0
    @Published var wordsToday: Int = 0
    @Published var timeTodayMinutes: Double = 0
    
    @Published var currentStreak: Int = 0
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Computed Properties
    var averageScorePercentage: Double {
        guard !quizzes.isEmpty else { return 0.0 }
        return quizzes.map { $0.scorePercentage }.reduce(0.0, +) / Double(quizzes.count)
    }
    
    var correctAnswerCount: Int {
        responses.filter { $0.isCorrect }.count
    }
    
    var incorrectAnswerCount: Int {
        responses.count - correctAnswerCount
    }
    
    var totalWordsRead: Int {
        quizzes.map { Int($0.numWords) }.reduce(0, +)
    }
    
    var totalTimeInMinutes: Double {
        Double(quizzes.map { Int($0.timeInSeconds) }.reduce(0, +)) / 60.0
    }
   

    func calculateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        
        // Ordenar quizzes por fecha (más reciente primero)
        let sortedQuizzes = quizzes.sorted { $0.quizDate > $1.quizDate }
        
        var currentDate = today
        
        for quiz in sortedQuizzes {
            let quizDate = calendar.startOfDay(for: quiz.quizDate)
            
            if quizDate == currentDate {
                // Si encontramos un quiz para el día actual
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if quizDate < currentDate {
                // Si hay un hueco en las fechas, romper la racha
                break
            }
        }
        
        currentStreak = streak
    }

    // MARK: - Data Methods
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            quizzes = try modelContext.fetch(FetchDescriptor<QuizItem>())
            responses = try modelContext.fetch(FetchDescriptor<ResponseItem>())
            calculateDailyMetrics()
            calculateStreak() // Calcular la racha
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
        
    
    // MARK: - Métricas diarias
    private func calculateDailyMetrics() {
        // Obtener la fecha actual sin componente de tiempo
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Filtrar quizzes del día actual
        let todaysQuizzes = quizzes.filter { quiz in
            calendar.isDate(quiz.quizDate, inSameDayAs: today)
        }
        
        // Calcular métricas
        quizzesToday = todaysQuizzes.count
        wordsToday = todaysQuizzes.map { Int($0.numWords) }.reduce(0, +)
        timeTodayMinutes = Double(todaysQuizzes.map { Int($0.timeInSeconds) }.reduce(0, +)) / 60
    }
    
    // Resto de tus métodos existentes...
    func questionTypePerformance() -> [(type: String, percentCorrect: Double)] {
        let grouped = Dictionary(grouping: responses, by: { $0.questionType })
        return grouped.map { key, values in
            let correct = values.filter { $0.isCorrect }.count
            let percent = (Double(correct) / Double(values.count)) * 100.0
            return (key, percent)
        }.sorted { $0.type < $1.type }
    }
    
    func categoryPerformance() -> [(category: String, averageScore: Double)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let avg = values.map { $0.scorePercentage }.reduce(0.0, +) / Double(values.count)
            return (key, avg)
        }.sorted { $0.category < $1.category }
    }
    
    func wordsByCategory() -> [(category: String, count: Int)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let count = values.map { Int($0.numWords) }.reduce(0, +)
            return (key, count)
        }.sorted { $0.category < $1.category }
    }
    
    func timeByCategoryInMinutes() -> [(category: String, minutes: Double)] {
        let grouped = Dictionary(grouping: quizzes, by: { $0.category })
        return grouped.map { key, values in
            let seconds = values.map { Int($0.timeInSeconds) }.reduce(0, +)
            return (key, Double(seconds) / 60.0)
        }.sorted { $0.category < $1.category }
    }
    
    func sortedQuizzesByDate() -> [QuizItem] {
        quizzes.sorted { $0.quizDate < $1.quizDate }
    }
    
    func quizCount() -> Int {
        quizzes.count
    }
}
