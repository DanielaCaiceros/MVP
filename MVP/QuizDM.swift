//
//  QuizDM.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import Foundation

struct Response: Identifiable {
    let id: UUID
    let typeQuestion: String // "vocabulary" or "reading comprehension"
    let answer: Int // 1 = correct, 0 = incorrect
    let quizId: UUID
    let category: String // "easy", "medium", "hard"
    
    init(id: UUID = UUID(), typeQuestion: String, answer: Int, quizId: UUID, category: String) {
        self.id = id
        self.typeQuestion = typeQuestion
        self.answer = answer
        self.quizId = quizId
        self.category = category
    }
}

struct Quiz: Identifiable {
    let id: UUID
    let numWords: Int
    let time: Int // seconds
    let quizDate: Date
    let category: String // "easy", "medium", "hard"
    let score: Double // percentage
    
    init(id: UUID = UUID(), numWords: Int, time: Int, quizDate: Date, category: String, score: Double) {
        self.id = id
        self.numWords = numWords
        self.time = time
        self.quizDate = quizDate
        self.category = category
        self.score = score
    }
}

class UserProgressData: ObservableObject {
    @Published var responses: [Response] = []
    @Published var quizzes: [Quiz] = []
    
    // Computed properties for charts
    var totalScore: Double {
        guard !quizzes.isEmpty else { return 0 }
        return quizzes.reduce(0) { $0 + $1.score } / Double(quizzes.count)
    }
    
    var totalCorrectAnswers: Int {
        responses.filter { $0.answer == 1 }.count
    }
    
    var correctAnswersByType: [String: Int] {
        Dictionary(grouping: responses.filter { $0.answer == 1 }, by: { $0.typeQuestion })
            .mapValues { $0.count }
    }
    
    var quizzesTaken: Int {
        quizzes.count
    }
    
    var totalWordsRead: Int {
        quizzes.reduce(0) { $0 + $1.numWords }
    }
    
    var totalReadingTime: Int {
        quizzes.reduce(0) { $0 + $1.time }
    }
    
    var readingTimeByCategory: [String: Int] {
        Dictionary(grouping: quizzes, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.time } }
    }
    
    var scoreByCategory: [String: Double] {
        Dictionary(grouping: quizzes, by: { $0.category })
            .mapValues { quizzes in
                quizzes.reduce(0.0) { $0 + $1.score } / Double(quizzes.count)
            }
    }
    
    // Generate sample data
    func generateSampleData() {
        let categories = ["easy", "medium", "hard"]
        let questionTypes = ["vocabulary", "reading comprehension"]
        
        // Generate 30 quizzes over the last 3 months
        for i in 0..<30 {
            let daysAgo = Int.random(in: 0...90)
            let category = categories.randomElement()!
            let numWords = Int.random(in: 50...500)
            let time = Int.random(in: 60...1800) // 1-30 minutes
            let score = Double.random(in: 30...100)
            
            let quizDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
            let quiz = Quiz(
                numWords: numWords,
                time: time,
                quizDate: quizDate,
                category: category,
                score: score
            )
            quizzes.append(quiz)
            
            // Generate 10-20 responses per quiz
            let numResponses = Int.random(in: 10...20)
            for _ in 0..<numResponses {
                let type = questionTypes.randomElement()!
                let answer = Int.random(in: 0...1)
                
                let response = Response(
                    typeQuestion: type,
                    answer: answer,
                    quizId: quiz.id,
                    category: category
                )
                responses.append(response)
            }
        }
    }
}
