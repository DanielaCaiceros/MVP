import SwiftUI
import Charts

struct ScoreOverTimeChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Progression Over Time")
                .font(.headline)
            
            Chart {
                // Línea de puntajes
                ForEach(viewModel.sortedQuizzesByDate(), id: \.quizId) { quiz in
                    LineMark(
                        x: .value("Date", quiz.quizDate),
                        y: .value("Score", quiz.scorePercentage)
                    )
                    .foregroundStyle(.blue)
                    .symbol(.circle)
                }
                
                // Línea de promedio
                RuleMark(
                    y: .value("Average", viewModel.averageScorePercentage)
                )
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .annotation(position: .top, alignment: .leading) {
                    Text("Average: \(viewModel.averageScorePercentage, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .frame(height: 200)
            .chartYScale(domain: 0...100)
        }
    }
}
