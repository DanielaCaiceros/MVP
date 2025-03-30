//
//  QuizAmountSelectorView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI

struct QuizAmountSelectorView: View {
    @State private var quizAmount: Int = 8
    var body: some View {
        VStack(alignment: .center){
            Text("How many quizzes do you want to solve?")
                .font(.title)
                .frame(maxWidth: .infinity)  
                .multilineTextAlignment(.center)
            Spacer()
            HStack{
                Button {
                    if quizAmount > 1 {
                        quizAmount -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                    .font(.system(size: 50))
                }
                Text("\(quizAmount)")
                    .font(.system(size: 150))
                    .padding(.horizontal)
                Button {
                    if quizAmount < 20 {
                        quizAmount += 1
                    }
                }label: {
                    Image(systemName: "plus")
                        .font(.system(size: 50))
                }
            }
            .font(.title)
            .foregroundStyle(mainColor)
            .bold()
            
                
            
            Spacer()
            Button{
                print("Continue")
            } label: {
                Text("Start reading!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .background(mainColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(mainColor)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
        }
        .padding()
    }
}

#Preview {
    QuizAmountSelectorView()
}
