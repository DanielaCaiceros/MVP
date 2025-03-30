//
//  ResponseItem.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import SwiftData
import Foundation

@Model
final class ResponseItem {
    var questionType: String
    var isCorrect: Bool
    var quizId: Int32
    
    init(
        questionType: String,
        isCorrect: Bool,
        quizId: Int32
    ) {
        self.questionType = questionType
        self.isCorrect = isCorrect
        self.quizId = quizId
    }
}
