import SwiftUI
import Charts

struct QuestionTypePerformanceChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance by Question Type")
                .font(.headline)
            
            Chart(viewModel.questionTypePerformance(), id: \.type) { item in
                BarMark(
                    x: .value("Type", item.type),
                    y: .value("Percent", item.percentCorrect)
                )
                .foregroundStyle(by: .value("Type", item.type))
                .annotation(position: .top) {
                    Text("\(item.percentCorrect, specifier: "%.1f")%")
                        .font(.caption)
                }
            }
            .frame(height: 200)
            .chartYScale(domain: 0...100)
        }
    }
}
