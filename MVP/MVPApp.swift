//
//  MVPApp.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import SwiftUI
import SwiftData

@main
struct MVPApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            QuizItem.self,
            ResponseItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView(modelContext: sharedModelContainer.mainContext)
            }
            .modelContainer(sharedModelContainer)
        }
    }
}
