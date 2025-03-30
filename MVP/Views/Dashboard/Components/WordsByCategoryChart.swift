import SwiftUI
import Charts

struct WordsByCategoryChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Words Read by Category")
                .font(.headline)
            
            Chart(viewModel.wordsByCategory(), id: \.category) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Words", item.count)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .top) {
                    Text("\(item.count)")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}
