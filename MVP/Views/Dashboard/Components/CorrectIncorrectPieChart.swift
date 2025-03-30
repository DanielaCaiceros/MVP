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
                    Text("\(percentageCorrect, specifier: "%.0f")%")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                SectorMark(
                    angle: .value("Incorrect", viewModel.incorrectAnswerCount),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(Color.red)
            }
            .chartLegend(position: .bottom, alignment: .center)
            .frame(height: 200)
        }
    }
    
    private var percentageCorrect: Double {
        guard viewModel.responses.count > 0 else { return 0 }
        return (Double(viewModel.correctAnswerCount) / Double(viewModel.responses.count)) * 100
    }
}
