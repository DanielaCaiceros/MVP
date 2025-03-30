import SwiftUICore
import Charts
struct ScoreDistributionChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Distribution by Category")
                .font(.headline)
            
            Chart {
                ForEach(viewModel.quizzes) { quiz in
                    PointMark(
                        x: .value("Category", quiz.category),
                        y: .value("Score", quiz.scorePercentage)
                    )
                    .foregroundStyle(by: .value("Category", quiz.category))
                    .symbol(.circle)
                }
            }
            .frame(height: 200)
            .chartYScale(domain: 0...100)
        }
    }
}
