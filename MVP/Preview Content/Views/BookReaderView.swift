//
//  BookReaderView.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//
import SwiftUI

struct BookReaderView: View {
    let book: Book
    @Environment(\.presentationMode) var presentationMode
    @State private var paragraphs: [String] = []
    @State private var currentPage = 0
    
    // Persistencia de preferencias
    @AppStorage("readerFontSize") private var fontSize: Double = 18
    @AppStorage("readerFontType") private var storedFontType = FontType.system.rawValue
    @AppStorage("readerLineSpacing") private var lineSpacing: Double = 1.5
    @AppStorage("readerPadding") private var padding: Double = 20
    @AppStorage("readerTheme") private var selectedTheme = Theme.light.rawValue
    
    @State private var showSettings = false
    @State private var showThemes = false
    
    // Configuración de fuentes
    enum FontType: String, CaseIterable {
        case system = "System"
        case serif = "Georgia"
        case sansSerif = "Avenir"
        case monospace = "Courier New"
        
        var font: Font {
            switch self {
            case .system: return .body
            case .serif: return .custom("Georgia", size: 16)
            case .sansSerif: return .custom("Avenir", size: 16)
            case .monospace: return .custom("Courier New", size: 16)
            }
        }
    }
    
    // Temas predefinidos
    enum Theme: String, CaseIterable {
        case light = "Claro"
        case dark = "Oscuro"
        case sepia = "Sépia"
        case solarized = "Solarizado"
        
        var background: Color {
            switch self {
            case .light: return .white
            case .dark: return .black
            case .sepia: return Color(red: 0.95, green: 0.93, blue: 0.86)
            case .solarized: return Color(red: 0.99, green: 0.96, blue: 0.89)
            }
        }
        
        var textColor: Color {
            switch self {
            case .light: return .black
            case .dark: return .white
            case .sepia, .solarized: return Color(red: 0.24, green: 0.21, blue: 0.16)
            }
        }
    }
    
    // Propiedades computadas para el tema actual
    private var currentTheme: Theme {
        Theme(rawValue: selectedTheme) ?? .light
    }
    
    private var currentFont: FontType {
        FontType(rawValue: storedFontType) ?? .system
    }
    
    var body: some View {
        ZStack {
            currentTheme.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Barra de navegación superior
                navigationBar
                
                // Contenido del libro con gestos
                GeometryReader { geometry in
                    TabView(selection: $currentPage) {
                        ForEach(0..<paragraphs.count, id: \.self) { index in
                            Text(paragraphs[index])
                                .font(currentFont.font)
                                .foregroundColor(currentTheme.textColor)
                                .font(.system(size: fontSize))
                                .lineSpacing(lineSpacing)
                                .padding(padding)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height,
                                       alignment: .topLeading)
                                .tag(index)
                                .background(currentTheme.background)
                                .gesture(
                                    DragGesture()
                                        .onEnded { value in
                                            if value.translation.width < -100 {
                                                withAnimation {
                                                    goToNextPage()
                                                }
                                            } else if value.translation.width > 100 {
                                                withAnimation {
                                                    goToPreviousPage()
                                                }
                                            }
                                        }
                                )
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                
                // Controles de página
                pageControls
            }
            
            // Panel de configuración
            if showSettings {
                settingsPanel
            }
            
            // Selector de temas
            if showThemes {
                themesPanel
            }
        }
        .task {
            await loadAndFormatContent()
        }
    }
    
    // MARK: - Componentes personalizados
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            .padding(.leading)
            
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.horizontal)
                .foregroundColor(currentTheme.textColor)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    showSettings.toggle()
                    showThemes = false
                }
            }) {
                Image(systemName: "textformat")
                    .font(.headline)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            .padding(.trailing)
        }
        .padding(.vertical)
        .background(currentTheme.background.opacity(0.9))
    }
    
    private var pageControls: some View {
        HStack {
            Button(action: {
                withAnimation {
                    goToPreviousPage()
                }
            }) {
                Image(systemName: "chevron.left")
                    .padding()
            }
            .disabled(currentPage == 0)
            
            Spacer()
            
            Text("\(currentPage + 1)/\(paragraphs.count)")
                .font(.subheadline)
                .monospacedDigit()
                .foregroundColor(currentTheme.textColor)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    goToNextPage()
                }
            }) {
                Image(systemName: "chevron.right")
                    .padding()
            }
            .disabled(currentPage == paragraphs.count - 1)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(currentTheme.background.opacity(0.9))
    }
    
    private var settingsPanel: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Ajustes de lectura")
                    .font(.headline)
                
                // Control de tamaño de fuente
                HStack {
                    Text("Tamaño:")
                    Slider(value: $fontSize, in: 12...28, step: 1)
                    Text("\(Int(fontSize))")
                        .frame(width: 30)
                }
                
                // Selector de tipo de fuente
                Picker("Fuente:", selection: $storedFontType) {
                    ForEach(FontType.allCases, id: \.self) { font in
                        Text(font.rawValue).tag(font.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Control de interlineado
                HStack {
                    Text("Espaciado:")
                    Slider(value: $lineSpacing, in: 1...3, step: 0.1)
                    Text(String(format: "%.1f", lineSpacing))
                        .frame(width: 30)
                }
                
                // Botón para temas
                Button(action: {
                    withAnimation {
                        showThemes = true
                        showSettings = false
                    }
                }) {
                    HStack {
                        Image(systemName: "paintpalette")
                        Text("Cambiar tema")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                // Botón para cerrar
                Button("Listo") {
                    withAnimation {
                        showSettings = false
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .transition(.move(edge: .bottom))
    }
    
    private var themesPanel: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Seleccionar tema")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Button(action: {
                            withAnimation {
                                selectedTheme = theme.rawValue
                                showThemes = false
                                showSettings = true
                            }
                        }) {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(theme.background)
                                    .frame(height: 80)
                                    .overlay(
                                        Text("Ejemplo")
                                            .foregroundColor(theme.textColor)
                                    )
                                Text(theme.rawValue)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Button("Cancelar") {
                    withAnimation {
                        showThemes = false
                        showSettings = true
                    }
                }
                .padding(.top)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .transition(.move(edge: .bottom))
    }
    
    // MARK: - Funciones de navegación
    
    private func goToPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    private func goToNextPage() {
        if currentPage < paragraphs.count - 1 {
            currentPage += 1
        }
    }
    
    // MARK: - Lógica de contenido
    
    private func loadAndFormatContent() async {
        guard let url = book.textFileURL else {
            paragraphs = ["Formato no disponible"]
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fullText = String(data: data, encoding: .utf8) ?? ""
            paragraphs = splitIntoPages(text: fullText)
        } catch {
            paragraphs = ["Error al cargar el libro: \(error.localizedDescription)"]
        }
    }
    
    private func splitIntoPages(text: String) -> [String] {
        // Primero normalizamos los saltos de línea
        let normalizedText = text.replacingOccurrences(of: "\r\n", with: "\n")
                                .replacingOccurrences(of: "\r", with: "\n")
        
        // Dividimos en párrafos (doble salto de línea)
        let rawParagraphs = normalizedText.components(separatedBy: "\n\n")
                                         .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        var processedPages: [String] = []
        var currentPageContent = ""
        
        // Tamaño aproximado de página (ajústalo según necesidades)
        let maxPageSize = 1500 // caracteres
        
        for paragraph in rawParagraphs {
            let trimmedParagraph = paragraph.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Si el párrafo es muy grande, lo dividimos
            if trimmedParagraph.count > maxPageSize {
                let sentences = trimmedParagraph.components(separatedBy: ". ")
                var currentSentenceGroup = ""
                
                for sentence in sentences {
                    let testContent = currentSentenceGroup.isEmpty ? sentence : currentSentenceGroup + ". " + sentence
                    
                    if testContent.count + currentPageContent.count < maxPageSize {
                        currentSentenceGroup = testContent
                    } else {
                        if !currentPageContent.isEmpty {
                            processedPages.append(currentPageContent)
                            currentPageContent = ""
                        }
                        processedPages.append(testContent)
                        currentSentenceGroup = ""
                    }
                }
                
                if !currentSentenceGroup.isEmpty {
                    if currentSentenceGroup.count + currentPageContent.count < maxPageSize {
                        currentPageContent += (currentPageContent.isEmpty ? "" : "\n\n") + currentSentenceGroup
                    } else {
                        if !currentPageContent.isEmpty {
                            processedPages.append(currentPageContent)
                        }
                        currentPageContent = currentSentenceGroup
                    }
                }
            } else {
                // Verificamos si podemos añadir este párrafo a la página actual
                if currentPageContent.isEmpty {
                    currentPageContent = trimmedParagraph
                } else if currentPageContent.count + trimmedParagraph.count + 2 < maxPageSize { // +2 por los \n\n
                    currentPageContent += "\n\n" + trimmedParagraph
                } else {
                    processedPages.append(currentPageContent)
                    currentPageContent = trimmedParagraph
                }
            }
        }
        
        // Añadimos el último contenido si existe
        if !currentPageContent.isEmpty {
            processedPages.append(currentPageContent)
        }
        
        return processedPages.isEmpty ? ["Contenido no disponible"] : processedPages
    }
}
