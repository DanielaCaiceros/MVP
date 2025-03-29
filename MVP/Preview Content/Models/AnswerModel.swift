//
//  AnswerModel.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import Foundation

struct Answer: Codable, Identifiable {
    var id = UUID()
    let answerText: String
    let correct: Bool
}
