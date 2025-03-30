import SwiftUI
import Charts

struct ScoreDetailView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Main title
                HStack {
                    Text("Score Count")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Time period selector
                ScrollView {
                    VStack(spacing: 24) {
                        
                        ScoreDistributionChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)

                        ScoreDistributionChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)

                        CorrectIncorrectPieChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)

                        QuestionTypePerformanceChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)

                        
                        Spacer(minLength: 80)  // Space for tab bar
                    }
                }
            }
        }
    }
}

// Add this to your AnalyticsViewModel class:
// var totalQuizCount: Int = 0
