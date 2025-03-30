import SwiftUI
import SwiftData

import SwiftUI

struct DashboardView: View {
    // Datos mock para la vista
    @State private var currentStreak: Int = 6
    @State private var quizzesToday: Int = 3
    @State private var wordsToday: Int = 2450
    @State private var timeTodayMinutes: Int = 28
    @State private var averageScorePercentage: Double = 82.5
    @State private var totalQuizzes: Int = 27
    @State private var showQuizDetail = false
    @State private var showScoreDetail = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(currentDateFormatted())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Resumen")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(mainColor)
                    }
                    Spacer()
                    
                    // Racha actual
                    HStack(spacing: 4) {
                        Text("\(currentStreak)")
                            .fontWeight(.bold)
                        Text("🔥")
                    }
                    .padding(8)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.2))
                    )
                    
                    // Avatar de usuario
                    Circle()
                        .fill(Color.pink.opacity(0.7))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        )
                }
                .padding(.horizontal)
                
                // Anillos de actividad
                activityRingsCard
                
                // Tarjetas de estadísticas
                HStack(spacing: 16) {
                    quizCountCard
                    averageScoreCard
                }
                .padding(.horizontal)
                .frame(height: 200)
                
                // Banner de desafío
                challengeBanner
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showQuizDetail) {
            QuizStatsDetailView(stats: mockQuizStats)
        }
        .sheet(isPresented: $showScoreDetail) {
            ScoreStatsDetailView(stats: mockScoreStats)
        }
    }
    
    // MARK: - Componentes
    
    private var activityRingsCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Progreso Diario")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.horizontal)
                
                Divider()
                
                HStack(alignment: .center, spacing: 20) {
                    // Anillos de actividad
                    ZStack(alignment: .center) {
                        // Anillo exterior (quizzes)
                        Circle()
                            .stroke(Color.red.opacity(0.3), lineWidth: 20)
                            .frame(width: 150, height: 150)
                        Circle()
                            .trim(from: 0, to: min(CGFloat(quizzesToday) / 5, 1))
                            .stroke(Color.red, lineWidth: 20)
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))
                        
                        // Anillo medio (palabras)
                        Circle()
                            .stroke(Color.green.opacity(0.3), lineWidth: 20)
                            .frame(width: 110, height: 110)
                        Circle()
                            .trim(from: 0, to: min(CGFloat(wordsToday) / 7500, 1))
                            .stroke(Color.green, lineWidth: 20)
                            .frame(width: 110, height: 110)
                            .rotationEffect(.degrees(-90))
                        
                        // Anillo interior (tiempo)
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 20)
                            .frame(width: 70, height: 70)
                        Circle()
                            .trim(from: 0, to: min(CGFloat(timeTodayMinutes) / 30, 1))
                            .stroke(Color.blue, lineWidth: 20)
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-90))
                    }
                    .padding(.leading, 40)
                    
                    // Leyendas
                    VStack(alignment: .leading, spacing: 5) {
                        VStack(alignment: .leading) {
                            Text("Quizzes")
                                .font(.headline)
                            Text("\(quizzesToday)/5")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.red)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Palabras")
                                .font(.headline)
                            Text("\(wordsToday)/7500")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Minutos")
                                .font(.headline)
                            Text("\(timeTodayMinutes)/30")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.leading)
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal)
    }
    
    private var quizCountCard: some View {
        Button(action: {
            showQuizDetail = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Total Quizzes")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading) {
                        Text("Todos")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(totalQuizzes)")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)
                    
                    // Gráfico simple
                    HStack(spacing: 3) {
                        ForEach(0..<24, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 3, height: CGFloat.random(in: 2...20))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    // Marcadores de tiempo
                    HStack {
                        Text("12a")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("6a")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("12p")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("6p")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var averageScoreCard: some View {
        Button(action: {
            showScoreDetail = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Puntuación")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading) {
                        Text("Promedio")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f%%", averageScorePercentage))
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.cyan)
                    }
                    .padding(.horizontal)
                    
                    // Gráfico simple
                    HStack(spacing: 2) {
                        ForEach(0..<24, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 3, height: CGFloat.random(in: 2...20))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    // Marcadores de tiempo
                    HStack {
                        Text("12a")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("6a")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("12p")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("6p")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var challengeBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                    Text("Desafío")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Spacer()
                
                Text("NUEVO DESAFÍO")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.horizontal)
                
                Text("Comprensión de lectura")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text("15 min • Nivel medio")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
            }
            
            HStack {
                Spacer()
                Image(systemName: "book.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.secondary)
                    .padding(.trailing, 40)
            }
        }
        .frame(height: 200)
    }
    
    // MARK: - Funciones auxiliares
    
    private func currentDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date()).uppercased()
    }
    
    // MARK: - Datos mock para los sheets
    
    private var mockQuizStats: QuizStats {
        QuizStats(
            totalQuizzes: totalQuizzes,
            dailyAverage: 2.3,
            bestDay: "Martes",
            lastWeekData: [12, 15, 8, 10, 14, 9, 11]
        )
    }
    
    private var mockScoreStats: ScoreStats {
        ScoreStats(
            averageScore: averageScorePercentage,
            bestScore: 95.0,
            lastWeekData: [75, 82, 90, 78, 85, 88, 80],
            byCategory: [
                ("Vocabulario", 85.0),
                ("Comprensión", 79.0),
                ("Gramática", 91.0)
            ]
        )
    }
}

// Estructuras para los datos mock
struct QuizStats {
    let totalQuizzes: Int
    let dailyAverage: Double
    let bestDay: String
    let lastWeekData: [Int]
}

struct ScoreStats {
    let averageScore: Double
    let bestScore: Double
    let lastWeekData: [Double]
    let byCategory: [(String, Double)]
}

// Vistas para los sheets
struct QuizStatsDetailView: View {
    let stats: QuizStats
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Estadísticas de Quizzes")
                        .font(.title)
                        .bold()
                    
                    // Aquí puedes añadir más visualizaciones detalladas
                    // usando los datos de `stats`
                }
                .padding()
            }
            .navigationTitle("Detalle de Quizzes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {}
                }
            }
        }
    }
}

struct ScoreStatsDetailView: View {
    let stats: ScoreStats
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Estadísticas de Puntuación")
                        .font(.title)
                        .bold()
                    
                    // Aquí puedes añadir más visualizaciones detalladas
                    // usando los datos de `stats`
                }
                .padding()
            }
            .navigationTitle("Detalle de Puntuación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {}
                }
            }
        }
    }
}

// Preview
#Preview {
    DashboardView()
}
