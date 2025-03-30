import SwiftUI
import Charts

struct QuizCountDetailView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Main title
                HStack {
                    Text("Quiz Count")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Time period selector
                ScrollView {
                    VStack(spacing: 24) {
                        
                        
                        // Additional charts from your original view
                        QuizzesOverTimeChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        
                        TimeByCategoryChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        
                        WordsByCategoryChart(viewModel: viewModel)
                            .frame(height: 300)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        
                        Spacer(minLength: 80)  // Space for tab bar
                    }
                }
            }
        }
    }
}

// Add this to your AnalyticsViewModel class:
// var totalQuizCount: Int = 0
