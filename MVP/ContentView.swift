import SwiftUI
import SwiftData
import Charts

// MARK: - Data Models
@Model
final class QuizItem {
    var numQuiz: Int
    var numWords: Int
    var time: Int
    var quizDate: Date
    var category: String
    var score: Double
    
    @Relationship(deleteRule: .cascade) var responses = [ResponseItem]()
    
    init(numQuiz: Int, numWords: Int, time: Int, quizDate: Date, category: String, score: Double) {
        self.numQuiz = numQuiz
        self.numWords = numWords
        self.time = time
        self.quizDate = quizDate
        self.category = category
        self.score = score
    }
}

@Model
final class ResponseItem {
    var typeQuestion: String
    var answer: Int // 1 = correct, 0 = incorrect
    var quizID: Int
    
    init(typeQuestion: String, answer: Int, quizID: Int) {
        self.typeQuestion = typeQuestion
        self.answer = answer
        self.quizID = quizID
    }
}

// MARK: - Data Generation
class DataGenerator {
    static func generateSampleData(modelContext: ModelContext, numQuizzes: Int = 20, responsesPerQuiz: Int = 10) {
        let categories = ["easy", "medium", "hard"]
        let questionTypes = ["vocabulary", "reading comprehension"]
        
        for quizID in 1...numQuizzes {
            let category = categories.randomElement()!
            
            // Word count based on difficulty
            let numWords: Int
            switch category {
            case "easy":
                numWords = Int.random(in: 50...150)
            case "medium":
                numWords = Int.random(in: 150...300)
            default:
                numWords = Int.random(in: 300...500)
            }
            
            // Time spent based on word count and difficulty
            let baseTime = Double(numWords) * 1.2
            let timeSpent = Int(baseTime * (1 + Double.random(in: -0.2...0.2)))
            
            // Generate a date within the last 30 days
            let daysAgo = Int.random(in: 0...30)
            guard let quizDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) else {
                continue
            }
            
            // Create quiz
            let quiz = QuizItem(
                numQuiz: quizID,
                numWords: numWords,
                time: timeSpent,
                quizDate: quizDate,
                category: category,
                score: 0 // Will be calculated
            )
            
            // Generate responses
            var correctCount = 0
            for _ in 1...responsesPerQuiz {
                let questionType = questionTypes.randomElement()!
                let isCorrect: Bool
                
                // Determine if answer is correct (weighted by difficulty)
                switch category {
                case "easy":
                    isCorrect = Double.random(in: 0..<1) < 0.8
                case "medium":
                    isCorrect = Double.random(in: 0..<1) < 0.7
                default:
                    isCorrect = Double.random(in: 0..<1) < 0.6
                }
                
                let answer = isCorrect ? 1 : 0
                if isCorrect {
                    correctCount += 1
                }
                
                let response = ResponseItem(
                    typeQuestion: questionType,
                    answer: answer,
                    quizID: quizID
                )
                quiz.responses.append(response)
                modelContext.insert(response)
            }
            
            // Calculate quiz score
            quiz.score = (Double(correctCount) / Double(responsesPerQuiz)) * 100
            modelContext.insert(quiz)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
}

// MARK: - Analytics View Model
class AnalyticsViewModel: ObservableObject {
    @Published var quizzes: [QuizItem] = []
    @Published var responses: [ResponseItem] = []
    
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
    
    func loadData(modelContext: ModelContext) {
        let quizFetchDescriptor = FetchDescriptor<QuizItem>()
        let responseFetchDescriptor = FetchDescriptor<ResponseItem>()
        
        do {
            quizzes = try modelContext.fetch(quizFetchDescriptor)
            responses = try modelContext.fetch(responseFetchDescriptor)
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
}

// MARK: - Views
struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Overall Average Score
                AverageScoreView(viewModel: viewModel)
                
                // 2. Correct vs Incorrect Questions
                CorrectIncorrectPieChart(viewModel: viewModel)
                
                // 3. Performance by Question Type
                QuestionTypePerformanceChart(viewModel: viewModel)
                
                // 4. Number of Quizzes Taken Over Time
                QuizzesOverTimeChart(viewModel: viewModel)
                
                // 5. Words Read by Category
                WordsByCategoryChart(viewModel: viewModel)
                
                // 6. Time Spent Reading by Category
                TimeByCategoryChart(viewModel: viewModel)
                
                // 7. Score Over Time
                ScoreOverTimeChart(viewModel: viewModel)
                
                // 8. Score Distribution by Category
                ScoreDistributionChart(viewModel: viewModel)
                
                // Summary Statistics
                SummaryStatsView(viewModel: viewModel)
            }
            .padding()
        }
        .navigationTitle("User Performance Dashboard")
        .onAppear {
            viewModel.loadData(modelContext: modelContext)
        }
    }
}

// MARK: - Chart Components
struct AverageScoreView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overall Average Score")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                
                VStack {
                    Text("\(viewModel.averageScore, specifier: "%.1f")%")
                        .font(.title)
                        .bold()
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                        .opacity(0.5)
                    
                    Text("Passing Threshold (70%)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .frame(height: 120)
        }
    }
}

struct CorrectIncorrectPieChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Questions Answered")
                .font(.headline)
            
            Chart {
                SectorMark(
                    angle: .value("Correct", viewModel.correctAnswerCount),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(Color.green)
                .annotation(position: .overlay) {
                    Text("\(Int(Double(viewModel.correctAnswerCount) / Double(viewModel.responses.count) * 100))%")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                SectorMark(
                    angle: .value("Incorrect", viewModel.incorrectAnswerCount),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(Color.red)
                .annotation(position: .overlay) {
                    Text("\(Int(Double(viewModel.incorrectAnswerCount) / Double(viewModel.responses.count) * 100))%")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .chartLegend(position: .bottom, alignment: .center)
            .frame(height: 200)
        }
    }
}

struct QuestionTypePerformanceChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance by Question Type")
                .font(.headline)
            
            Chart(viewModel.questionTypePerformance(), id: \.type) { item in
                BarMark(
                    x: .value("Type", item.type),
                    y: .value("Percent Correct", item.percentCorrect)
                )
                .foregroundStyle(by: .value("Type", item.type))
                .annotation(position: .top) {
                    Text("\(item.percentCorrect, specifier: "%.1f")%")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}

struct QuizzesOverTimeChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Number of Quizzes Taken")
                .font(.headline)
            
            Chart(viewModel.sortedQuizzesByDate().enumerated().map { (index, quiz) in
                (date: quiz.quizDate, count: index + 1)
            }, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Cumulative Quizzes", item.count)
                )
                .symbol(.circle)
            }
            .frame(height: 200)
        }
    }
}

struct WordsByCategoryChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Words Read by Category")
                .font(.headline)
            
            Chart(viewModel.wordsByCategory(), id: \.category) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Words", item.count)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .top) {
                    Text("\(item.count)")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}

struct TimeByCategoryChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Time Spent Reading by Category")
                .font(.headline)
            
            Chart(viewModel.timeByCategory(), id: \.category) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Minutes", item.minutes)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .top) {
                    Text("\(item.minutes, specifier: "%.1f")")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}

struct ScoreOverTimeChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Progression Over Time")
                .font(.headline)
            
            Chart(viewModel.sortedQuizzesByDate()) { quiz in
                LineMark(
                    x: .value("Date", quiz.quizDate),
                    y: .value("Score", quiz.score)
                )
                .symbol(.circle)
                
                RuleMark(y: .value("Average", viewModel.averageScore))
                    .foregroundStyle(.green)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
            .frame(height: 200)
        }
    }
}

struct ScoreDistributionChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Distribution by Category")
                .font(.headline)
            
            Chart {
                ForEach(viewModel.quizzes, id: \.numQuiz) { quiz in
                    PointMark(
                        x: .value("Category", quiz.category),
                        y: .value("Score", quiz.score)
                    )
                    .foregroundStyle(by: .value("Category", quiz.category))
                }
            }
            .frame(height: 200)
        }
    }
}

struct SummaryStatsView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Overall Performance")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Correct Answers: \(viewModel.correctAnswerCount)/\(viewModel.responses.count) (\(Double(viewModel.correctAnswerCount) / Double(viewModel.responses.count) * 100, specifier: "%.1f")%)")
                Text("Total Words Read: \(viewModel.totalWordsRead)")
                Text("Total Reading Time: \(viewModel.totalTimeMinutes, specifier: "%.1f") minutes")
            }
            .font(.subheadline)
            
            Divider()
            
            Text("Category Performance")
                .font(.headline)
            
            ForEach(viewModel.categoryPerformance(), id: \.category) { item in
                Text("\(item.category.capitalized): \(item.averageScore, specifier: "%.1f")%")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
