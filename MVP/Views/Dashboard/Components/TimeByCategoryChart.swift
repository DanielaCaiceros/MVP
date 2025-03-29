
import SwiftUI
import Charts


struct TimeByCategoryChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Time Spent Reading by Category")
                .font(.headline)
            
            Chart(viewModel.timeByCategory(), id: \.category) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Minutes", item.minutes)
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .top) {
                    Text("\(item.minutes, specifier: "%.1f")")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}
