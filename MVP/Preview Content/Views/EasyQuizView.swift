//
//  EasyQuizView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI

struct EasyQuizView: View {
    @State public var questionType: String
    @State public var question: String
    @State public var options: [Answer]
    
    var body: some View {
        let shuffledAnswers = options.shuffled()
        let isVocabQuestion = questionType == "Vocabulary"
        VStack{
            Spacer()
            HStack{
                HStack{
                    Image(systemName: isVocabQuestion ? "character.book.closed" : "magnifyingglass")
                        .font(.title)
                    Text(questionType)
                        .font(.title2)
                }
                .padding(.bottom)
                .bold()
                
                    
                Spacer()
            }
            Spacer()
            
            HStack{
                Image("Calli")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .topLeading)
                
                DialogBoxView(message: question)
                    .offset(y: -35)
                Spacer()
            }
            
            Spacer()
            ForEach(shuffledAnswers.indices, id: \.self){i in
                Button{
                    
                } label: {
                    AnswerButtonView(answer: shuffledAnswers[i], isSelected: false)
                }
            }
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    EasyQuizView(questionType: "Reading\nComprehension", question: "Question?", options: [Answer(answerText: "Option 1", correct: true), Answer(answerText: "Option 2", correct: false), Answer(answerText: "Option 3", correct: false)])
}
