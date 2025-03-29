import Foundation
import SwiftData

class DataGenerator {
    static func generateSampleData(modelContext: ModelContext, numQuizzes: Int = 20, responsesPerQuiz: Int = 10) {
        let categories = ["easy", "medium", "hard"]
        let questionTypes = ["vocabulary", "reading comprehension"]
        
        for quizID in 1...numQuizzes {
            let category = categories.randomElement()!
            
            let numWords: Int
            switch category {
            case "easy": numWords = Int.random(in: 50...150)
            case "medium": numWords = Int.random(in: 150...300)
            default: numWords = Int.random(in: 300...500)
            }
            
            let baseTime = Double(numWords) * 1.2
            let timeSpent = Int(baseTime * (1 + Double.random(in: -0.2...0.2)))
            let daysAgo = Int.random(in: 0...30)
            guard let quizDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) else { continue }
            
            let quiz = QuizItem(
                numQuiz: quizID,
                numWords: numWords,
                time: timeSpent,
                quizDate: quizDate,
                category: category,
                score: 0
            )
            
            var correctCount = 0
            for _ in 1...responsesPerQuiz {
                let questionType = questionTypes.randomElement()!
                let isCorrect: Bool
                
                switch category {
                case "easy": isCorrect = Double.random(in: 0..<1) < 0.8
                case "medium": isCorrect = Double.random(in: 0..<1) < 0.7
                default: isCorrect = Double.random(in: 0..<1) < 0.6
                }
                
                let answer = isCorrect ? 1 : 0
                if isCorrect { correctCount += 1 }
                
                let response = ResponseItem(
                    typeQuestion: questionType,
                    answer: answer,
                    quizID: quizID
                )
                quiz.responses.append(response)
                modelContext.insert(response)
            }
            
            quiz.score = (Double(correctCount) / Double(responsesPerQuiz)) * 100
            modelContext.insert(quiz)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving sample data: \(error)")
        }
    }
}
