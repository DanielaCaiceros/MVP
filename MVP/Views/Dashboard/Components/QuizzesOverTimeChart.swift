import SwiftUI
import Charts

struct QuizzesOverTimeChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Quizzes Over Time")
                .font(.headline)
            
            
            Chart {
                ForEach(viewModel.sortedQuizzesByDate().enumerated().map { index, quiz in
                    (date: quiz.quizDate, count: index + 1)
                }, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Count", item.count)
                    )
                    .symbol(.circle)
                }
            }
            .frame(height: 200)
        }
    }
}
