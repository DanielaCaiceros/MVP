
import SwiftUI
import Charts

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
