//
//  AverageScoreView.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import SwiftUICore

// MARK: - Chart Components
struct AverageScoreView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overall Average Score")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                
                VStack {
                    Text("\(viewModel.averageScore, specifier: "%.1f")%")
                        .font(.title)
                        .bold()
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                        .opacity(0.5)
                    
                    Text("Passing Threshold (70%)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .frame(height: 120)
        }
    }
}
