//
//  QuizItem.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import Foundation
import SwiftData

// MARK: - Data Models
@Model
final class QuizItem {
    var numQuiz: Int
    var numWords: Int
    var time: Int
    var quizDate: Date
    var category: String
    var score: Double
    
    @Relationship(deleteRule: .cascade) var responses = [ResponseItem]()
    
    init(numQuiz: Int, numWords: Int, time: Int, quizDate: Date, category: String, score: Double) {
        self.numQuiz = numQuiz
        self.numWords = numWords
        self.time = time
        self.quizDate = quizDate
        self.category = category
        self.score = score
    }
}
