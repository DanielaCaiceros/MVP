//
//  QuizAmountSelectorView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI
struct QuizAmountSelectorView: View {
    @Binding var quizAmount: Int
    @Environment(\.dismiss) var dismiss
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("How many quizzes do you want to solve?")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            HStack {
                QuizAdjustButton(systemImage: "minus") {
                    quizAmount = max(1, quizAmount - 1)
                }
                
                Text("\(quizAmount)")
                    .font(.system(size: 80, weight: .bold))
                    .padding(.horizontal)
                
                QuizAdjustButton(systemImage: "plus") {
                    quizAmount = min(20, quizAmount + 1)
                }
            }
            
            Button {
                            onStart()
                            dismiss() // Cierra el selector
                        } label: {
                            Text("Start reading!")
                                
                        }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct QuizAdjustButton: View {
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .padding(20)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
        }
    }
}
