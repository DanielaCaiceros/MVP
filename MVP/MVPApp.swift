//
//  MVPApp.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import SwiftUI
import SwiftData

// MARK: - App Entry
@main
struct ReadingAnalyticsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView()
            }
        }
        .modelContainer(for: [QuizItem.self, ResponseItem.self]) { result in
            switch result {
            case .success(let container):
                // Check if we need to generate sample data
                let descriptor = FetchDescriptor<QuizItem>()
                if (try? container.mainContext.fetch(descriptor).isEmpty) ?? true {
                    DataGenerator.generateSampleData(modelContext: container.mainContext, numQuizzes: 30, responsesPerQuiz: 10)
                }
            case .failure(let error):
                print("Failed to create container: \(error)")
            }
        }
    }
}
