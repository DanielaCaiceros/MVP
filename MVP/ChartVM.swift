//
//  ChartVM.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import SwiftUI
import Charts

struct ProgressDashboardView: View {
    @StateObject private var userData = UserProgressData()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. General Score
                    ChartCard(title: "Overall Score", value: "\(String(format: "%.1f", userData.totalScore))%") {
                        Chart {
                            BarMark(
                                x: .value("Score", userData.totalScore)
                            )
                            .foregroundStyle(by: .value("Category", "Overall"))
                        }
                        .chartForegroundStyleScale(["Overall": .blue])
                    }
                    
                    // 2. Correct Answers
                    ChartCard(title: "Correct Answers", value: "\(userData.totalCorrectAnswers)/\(userData.responses.count)") {
                        Chart {
                            SectorMark(
                                angle: .value("Correct", userData.totalCorrectAnswers),
                                innerRadius: .ratio(0.6),
                                angularInset: 1
                            )
                            .foregroundStyle(.green)
                            
                            SectorMark(
                                angle: .value("Incorrect", userData.responses.count - userData.totalCorrectAnswers),
                                innerRadius: .ratio(0.6),
                                angularInset: 1
                            )
                            .foregroundStyle(.red)
                        }
                    }
                    
                    // 3. Correct Answers by Type
                    ChartCard(title: "Correct Answers by Type", value: "") {
                        Chart {
                            ForEach(userData.correctAnswersByType.sorted(by: <), id: \.key) { key, value in
                                BarMark(
                                    x: .value("Count", value),
                                    y: .value("Type", key)
                                )
                                .foregroundStyle(by: .value("Type", key))
                            }
                        }
                    }
                    
                    // 4. Quizzes Taken Over Time
                    ChartCard(title: "Quizzes Taken Over Time", value: "Total: \(userData.quizzesTaken)") {
                        Chart {
                            ForEach(userData.quizzes.sorted(by: { $0.quizDate < $1.quizDate })) { quiz in
                                LineMark(
                                    x: .value("Date", quiz.quizDate),
                                    y: .value("Count", userData.quizzes.filter { $0.quizDate <= quiz.quizDate }.count)
                                )
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .weekOfYear)) { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.month().day())
                            }
                        }
                    }
                    
                    // 5. Words Read
                    ChartCard(title: "Words Read", value: "Total: \(userData.totalWordsRead)") {
                        Chart {
                            ForEach(userData.quizzes.sorted(by: { $0.quizDate < $1.quizDate })) { quiz in
                                AreaMark(
                                    x: .value("Date", quiz.quizDate),
                                    y: .value("Words", userData.quizzes.filter { $0.quizDate <= quiz.quizDate }.reduce(0) { $0 + $1.numWords })
                                )
                                .interpolationMethod(.monotone)
                                .foregroundStyle(.linearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                            }
                        }
                    }
                    
                    // 6. Reading Time by Category
                    ChartCard(title: "Reading Time by Category", value: "Total: \(userData.totalReadingTime / 60) mins") {
                        Chart {
                            ForEach(userData.readingTimeByCategory.sorted(by: <), id: \.key) { key, value in
                                BarMark(
                                    x: .value("Category", key.capitalized),
                                    y: .value("Minutes", value / 60)
                                )
                                .foregroundStyle(by: .value("Category", key))
                            }
                        }
                    }
                    
                    // 7. Score by Category
                    ChartCard(title: "Score by Category", value: "") {
                        Chart {
                            ForEach(userData.scoreByCategory.sorted(by: <), id: \.key) { key, value in
                                BarMark(
                                    x: .value("Category", key.capitalized),
                                    y: .value("Score", value)
                                )
                                .annotation(position: .top) {
                                    Text("\(String(format: "%.1f", value))%")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Progress Dashboard")
            .onAppear {
                userData.generateSampleData()
            }
        }
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    let value: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            content
                .frame(height: 200)
                .padding(.vertical, 8)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
