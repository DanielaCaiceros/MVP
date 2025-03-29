
import SwiftUI
import Charts

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
