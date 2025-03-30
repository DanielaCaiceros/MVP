//
//  QuizItem.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import SwiftData
import Foundation

@Model
final class QuizItem {
    var quizId: Int32
    var numWords: Int32
    var timeInSeconds: Int32
    var quizDate: Date
    var category: String
    var scorePercentage: Double
    
    @Relationship(deleteRule: .cascade) var responses = [ResponseItem]()
    
    init(
        quizId: Int32,
        numWords: Int32,
        timeInSeconds: Int32,
        quizDate: Date,
        category: String,
        scorePercentage: Double
    ) {
        self.quizId = quizId
        self.numWords = numWords
        self.timeInSeconds = timeInSeconds
        self.quizDate = quizDate
        self.category = category
        self.scorePercentage = scorePercentage
    }
    
    // Propiedad computada para tiempo en minutos
    var timeInMinutes: Double {
        Double(timeInSeconds) / 60.0
    }
}
