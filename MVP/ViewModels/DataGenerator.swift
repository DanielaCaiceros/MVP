import Foundation
import SwiftData

class DataGenerator {
    func generateSampleData(modelContext: ModelContext, numQuizzes: Int32 = 20, responsesPerQuiz: Int32 = 10) {
        // Limpiar datos existentes primero (opcional)
        try? modelContext.delete(model: QuizItem.self)
        try? modelContext.delete(model: ResponseItem.self)
        
        let categories = ["easy", "medium", "hard"]
        let questionTypes = ["vocabulary", "reading comprehension"]
        let now = Date()
        
        for quizId in 1...numQuizzes {
            let category = categories.randomElement()!
            
            let numWords: Int32
            switch category {
            case "easy": numWords = Int32.random(in: 50...150)
            case "medium": numWords = Int32.random(in: 150...300)
            default: numWords = Int32.random(in: 300...500)
            }
            
            let baseTime = Double(numWords) * 1.2
            let timeSpent = Int32(baseTime * (1 + Double.random(in: -0.2...0.2)))
            let daysAgo = Int32.random(in: 0...30)
            let quizDate = Calendar.current.date(byAdding: .day, value: -Int(daysAgo), to: now)!
            
            let quiz = QuizItem(
                quizId: quizId,
                numWords: numWords,
                timeInSeconds: timeSpent,
                quizDate: quizDate,
                category: category,
                scorePercentage: 0.0
            )
            
            var correctCount: Int32 = 0
            for _ in 1...responsesPerQuiz {
                let questionType = questionTypes.randomElement()!
                let isCorrect: Bool
                
                switch category {
                case "easy": isCorrect = Double.random(in: 0..<1) < 0.8
                case "medium": isCorrect = Double.random(in: 0..<1) < 0.7
                default: isCorrect = Double.random(in: 0..<1) < 0.6
                }
                
                if isCorrect { correctCount += 1 }
                
                let response = ResponseItem(
                    questionType: questionType,
                    isCorrect: isCorrect,
                    quizId: quizId
                )
                quiz.responses.append(response)
                modelContext.insert(response)
            }
            
            quiz.scorePercentage = (Double(correctCount) / Double(responsesPerQuiz)) * 100.0
            modelContext.insert(quiz)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error guardando datos generados: \(error)")
        }
    }
}
