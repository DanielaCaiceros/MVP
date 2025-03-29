//
//  ResponseItem.swift
//  MVP
//
//  Created by Luis Garcia on 3/29/25.
//

import Foundation
import SwiftData

@Model
final class ResponseItem {
    var typeQuestion: String
    var answer: Int // 1 = correct, 0 = incorrect
    var quizID: Int
    
    init(typeQuestion: String, answer: Int, quizID: Int) {
        self.typeQuestion = typeQuestion
        self.answer = answer
        self.quizID = quizID
    }
}
