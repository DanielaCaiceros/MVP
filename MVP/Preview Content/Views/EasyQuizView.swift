import SwiftUI

struct EasyQuizView: View {
    @State public var questionType: String
    @State public var question: String
    @State public var options: [Answer]
    @State private var shuffledAnswers: [Answer] = []
    @State private var selectedAnswer: Answer? = nil
    @State private var answered: Bool = false
    @Environment(\.dismiss) var dismiss

    init(questionType: String, question: String, options: [Answer]) {
        self.questionType = questionType
        self.question = question
        self.options = options
        _shuffledAnswers = State(initialValue: options.shuffled()) // Shuffle only once
    }

    var body: some View {
            let isVocabQuestion = questionType == "Vocabulary"
            
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header
                    HStack {
                        Image(systemName: isVocabQuestion ? "character.book.closed" : "magnifyingglass")
                            .font(.title)
                        Text(questionType)
                            .font(.title2.bold())
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Contenido principal
                    VStack {
                        HStack {
                            Image("Calli")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            
                            DialogBoxView(message: question)
                                .offset(y: -35)
                            Spacer()
                        }
                        
                        // Opciones de respuesta
                        ForEach(shuffledAnswers.indices, id: \.self) { i in
                            AnswerButton(
                                answer: shuffledAnswers[i],
                                isSelected: selectedAnswer == shuffledAnswers[i],
                                action: {
                                    if !answered {
                                        answered = true
                                        selectedAnswer = shuffledAnswers[i]
                                    }
                                }
                            )
                        }
                        
                        // Resultado
                        if let selectedAnswer = selectedAnswer {
                            VStack {
                                Text("Respuesta correcta:")
                                    .font(.headline)
                                Text(options.first(where: { $0.correct })?.answerText ?? "")
                                    .bold()
                                    .padding()
                                Button {
                                    dismiss()
                                } label: {
                                    Text("Continuar leyendo")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(mainColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                               
                            }
                            .padding()
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
}

struct AnswerButton: View {
    let answer: Answer
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer.answerText)
                    .foregroundColor(isSelected ? (answer.correct ? .white : .white) : .primary)
                Spacer()
                if isSelected {
                    Image(systemName: answer.correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? (answer.correct ? Color.green : Color.red) : Color(.secondarySystemBackground))
            )
        }
    }
}

#Preview {
    EasyQuizView(questionType: "Vocabulary", question: "Question?", options: [
        Answer(answerText: "Option 1", correct: true),
        Answer(answerText: "Option 2", correct: false),
        Answer(answerText: "Option 3", correct: false)
    ])
}

