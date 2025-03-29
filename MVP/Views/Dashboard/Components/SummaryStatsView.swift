
import SwiftUI
import Charts

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
