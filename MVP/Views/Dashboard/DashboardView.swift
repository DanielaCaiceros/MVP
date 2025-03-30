import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AnalyticsViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AnalyticsViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with date and profile
                HStack {
                    VStack(alignment: .leading) {
                        Text(formattedDate())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Summary")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    
                    // Streak display with fire emoji
                    HStack(spacing: 4) {
                        Text("\(viewModel.currentStreak)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                        Text("🔥")
                            .font(.system(size: 16))
                    }
                    .padding(8)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.2))
                    )
                    
                    // Profile circle
                    Circle()
                        .fill(Color.pink.opacity(0.7))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        )
                }
                .padding(.horizontal)
                
                // Activity Rings Card
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemGray6))
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Reading Rings")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            //.padding(.bottom, 7.5)
                            .padding(.horizontal)
                        
                        Divider()
                            
                        
                        HStack(alignment: .center, spacing: 20) {
                            //Spacer()
                            // Activity rings visualization
                            ZStack (alignment: .center){
                                Circle()
                                    .stroke(Color.red.opacity(0.3), lineWidth: 20)
                                    .frame(width: 150, height: 150)
                                Circle()
                                    .trim(from: 0, to: min(CGFloat(viewModel.quizzesToday) / 5, 1))
                                    .stroke(Color.red, lineWidth: 20)
                                    .frame(width: 150, height: 150)
                                    .rotationEffect(.degrees(-90))
                                
                                Circle()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 20)
                                    .frame(width: 110, height: 110)
                                Circle()
                                    .trim(from: 0, to: min(CGFloat(viewModel.wordsToday) / 7500, 1))
                                    .stroke(Color.green, lineWidth: 20)
                                    .frame(width: 110, height: 110)
                                    .rotationEffect(.degrees(-90))
                                
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 20)
                                    .frame(width: 70, height: 70)
                                Circle()
                                    .trim(from: 0, to: CGFloat(min(viewModel.timeTodayMinutes / 30, 1))) //7500 x 30 min
                                    .stroke(Color.blue, lineWidth: 20)
                                    .frame(width: 70, height: 70)
                                    .rotationEffect(.degrees(-90))
                            }
                            .padding(.leading, 40)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                // Activity labels
                                VStack(alignment: .leading) {
                                    Text("Today Quizzes")
                                        .font(.headline)
                                    Text("\(viewModel.quizzesToday) / 5")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.red)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Today Words")
                                        .font(.headline)
                                    Text("\(viewModel.wordsToday) / 7500")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.green)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Today Minutes")
                                        .font(.headline)
                                    Text(String(format: "%.0f / 30", viewModel.timeTodayMinutes))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
                
                // Quizz Count and score Row
                HStack(spacing: 16) {
                    // Quizz count card - Ahora navegable
                    NavigationLink {
                        QuizCountDetailView(viewModel: viewModel)
                            //.foregroundColor(.primary)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemGray6))
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Quizzes Count")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.green)
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .padding(.horizontal, 8)
                                
                                VStack(alignment: .leading) {
                                    Text("All Time")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(viewModel.quizzes.count)")
                                        .font(.system(size: 35, weight: .bold))
                                        .foregroundColor(.purple)
                                }
                                .padding(.horizontal)
                                
                                // Simple bar chart
                                HStack(spacing: 3) {
                                    ForEach(0..<24, id: \.self) { i in
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 3, height: CGFloat.random(in: 2...20))
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 5)
                                
                                // Time indicators
                                HStack {
                                    Text("12a.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("6a.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("12p.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("6p.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                    
                    // Avg Score card - Ahora navegable
                    NavigationLink {
                        ScoreDetailView(viewModel: viewModel)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemGray6))
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Avg Score")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.green)
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .padding(.horizontal, 8)
                                
                                VStack(alignment: .leading) {
                                    Text("All Time")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.2f", viewModel.averageScorePercentage) + "%")
                                        .font(.system(size: 35, weight: .bold))
                                        .foregroundColor(.cyan)
                                }
                                .padding(.horizontal)
                                
                                // Simple bar chart
                                HStack(spacing: 2) {
                                    ForEach(0..<24, id: \.self) { i in
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 3, height: CGFloat.random(in: 2...20))
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 5)
                                
                                // Time indicators
                                HStack {
                                    Text("12a.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("6a.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("12p.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("6p.m.")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                // Fitness+ banner section
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemGray6))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Top section with logo
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.title2)
                            Text("Quiz+")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        Spacer()
                        
                        // Recommended workout text
                        Text("TRY A NEW CHALLENGE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.horizontal)
                        
                        Text("Word Challenge with Reading")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Text("15min • Difficult Level")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                    }
                    
                    // Placeholder for workout image
                    HStack {
                        Spacer()
                        Image(systemName: "book.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.secondary)
                            .padding(.trailing, 40)
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                
                .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemBackground))
        .task {
            await viewModel.loadData()
        }
    }
    
    // Helper function to format today's date like "SATURDAY 29 MAR"
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMM"
        return formatter.string(from: Date()).uppercased()
    }
}

// MARK: - Preview con Datos de Muestra
#Preview {
    // 1. Configurar contenedor en memoria
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: QuizItem.self, ResponseItem.self,
        configurations: config
    )
    
    // 2. Generar datos de muestra
    let sampleQuizzes = [
        QuizItem(
            quizId: 1,
            numWords: 120,
            timeInSeconds: 300,
            quizDate: Date(),//.addingTimeInterval(-86400 * 3),
            category: "easy",
            scorePercentage: 85.0
        ),
        QuizItem(
            quizId: 2,
            numWords: 180,
            timeInSeconds: 300,
            quizDate: Date(),//.addingTimeInterval(-86400 * 2),
            category: "medium",
            scorePercentage: 72.0
        ),
        QuizItem(
            quizId: 3,
            numWords: 250,
            timeInSeconds: 300,
            quizDate: Date(),//.addingTimeInterval(-86400),
            category: "hard",
            scorePercentage: 65.0
        ),
        QuizItem(
            quizId: 4,
            numWords: 140,
            timeInSeconds: 300,
            quizDate: Date(),
            category: "easy",
            scorePercentage: 88.0
        )
    ]
    
    let sampleResponses = [
        ResponseItem(questionType: "vocabulary", isCorrect: true, quizId: 1),
        ResponseItem(questionType: "vocabulary", isCorrect: false, quizId: 1),
        ResponseItem(questionType: "reading", isCorrect: true, quizId: 1),
        ResponseItem(questionType: "vocabulary", isCorrect: true, quizId: 2),
        ResponseItem(questionType: "reading", isCorrect: false, quizId: 2),
        ResponseItem(questionType: "reading", isCorrect: true, quizId: 3),
        ResponseItem(questionType: "vocabulary", isCorrect: true, quizId: 4)
    ]
    
    // 3. Insertar datos en el contenedor
    Task {
        sampleQuizzes.forEach { container.mainContext.insert($0) }
        sampleResponses.forEach { container.mainContext.insert($0) }
    }
    
    // 4. Retornar la vista con el contenedor
    return NavigationStack {
        DashboardView(modelContext: container.mainContext)
    }
    .modelContainer(container)
}
// Add these properties to your AnalyticsViewModel class:
// var overallScore: Double = 75.0
// var correctPercentage: Double = 85.0
// var quizCompletionRate: Double = 68.0
// var todayQuizCount: Int = 0
// var todayAverageScore: Double = 0.0
//
// And update your loadData() method to calculate these values
