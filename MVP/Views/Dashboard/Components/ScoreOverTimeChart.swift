

import SwiftUI
import Charts


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
