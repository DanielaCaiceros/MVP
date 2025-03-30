import SwiftUI

struct EasyQuizView: View {
    @State public var questionType: String
    @State public var question: String
    @State public var options: [Answer]
    @State private var shuffledAnswers: [Answer] = []
    @State private var selectedAnswer: Answer? = nil
    @State private var answered: Bool = false

    init(questionType: String, question: String, options: [Answer]) {
        self.questionType = questionType
        self.question = question
        self.options = options
        _shuffledAnswers = State(initialValue: options.shuffled()) // Shuffle only once
    }

    var body: some View {
        let isVocabQuestion = questionType == "Vocabulary"

        VStack {
            Spacer()
            HStack {
                HStack {
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

            HStack {
                Image("Calli")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .topLeading)

                DialogBoxView(message: question)
                    .offset(y: -35)
                Spacer()
            }

            Spacer()

            ForEach(shuffledAnswers.indices, id: \.self) { i in
                Button {
                    if !answered {
                        answered.toggle()
                        selectedAnswer = shuffledAnswers[i]
                    }
                } label: {
                    AnswerButtonView(answer: shuffledAnswers[i],
                                     isSelected: selectedAnswer == shuffledAnswers[i])
                }
            }

            if let selectedAnswer = selectedAnswer {
                VStack {
                    Text("The correct answer was:")
                    Text(options.first(where: { $0.correct })?.answerText ?? "")
                        .bold()
                }
                .foregroundColor(selectedAnswer.correct ? .green : .red)
                .padding(.top, 8)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    EasyQuizView(questionType: "Vocabulary", question: "Question?", options: [
        Answer(answerText: "Option 1", correct: true),
        Answer(answerText: "Option 2", correct: false),
        Answer(answerText: "Option 3", correct: false)
    ])
}
