//
//  DashboardView.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AnalyticsViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AnalyticsViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading data...")
            } else if let error = viewModel.errorMessage {
                ErrorView(error: error, retryAction: { Task { await viewModel.loadData() } })
            } else {
                contentView
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                AverageScoreView(viewModel: viewModel)
                CorrectIncorrectPieChart(viewModel: viewModel)
                QuestionTypePerformanceChart(viewModel: viewModel)
                QuizzesOverTimeChart(viewModel: viewModel)
                WordsByCategoryChart(viewModel: viewModel)
                TimeByCategoryChart(viewModel: viewModel)
                ScoreOverTimeChart(viewModel: viewModel)
                ScoreDistributionChart(viewModel: viewModel)
                SummaryStatsView(viewModel: viewModel)
            }
            .padding()
        }
        .navigationTitle("User Performance Dashboard")
        .refreshable {
            await viewModel.loadData()
        }
    }
}

// MARK: - Supporting Views
private struct ErrorView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.headline)
            Text(error)
                .foregroundColor(.red)
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Previews
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: QuizItem.self, ResponseItem.self, configurations: config)
    
    // Generate sample data
    DataGenerator.generateSampleData(modelContext: container.mainContext, numQuizzes: 5, responsesPerQuiz: 3)
    
    return DashboardView(modelContext: container.mainContext)
        .modelContainer(container)
}
