//
//  AnswerButtonView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI

struct AnswerButtonView: View {
    public var answer: Answer
    public var isSelected: Bool
    var body: some View {
        VStack{
            Text(answer.answerText)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(isSelected ? .white : .black)
                .bold(isSelected)
                .background(isSelected ? (answer.correct ? .green : .red) : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? (answer.correct ? .green : .red) : mainColor, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
        }
    }
}

#Preview {
    AnswerButtonView(answer: Answer(answerText: "Option", correct: false), isSelected: false)
}
