//
//  NetworkManager.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://gutendex.com/books"
    
    func fetchBooks(searchQuery: String? = nil, completion: @escaping ([Book]?) -> Void) {
        var components = URLComponents(string: baseURL)!
        
        // Añade parámetros de búsqueda si existen
        if let query = searchQuery?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            components.queryItems = [URLQueryItem(name: "search", value: query)]
        }
        
        guard let url = components.url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            // Manejo básico de errores
            if let error = error {
                print("🔴 Network error:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("🔴 No data received")
                completion(nil)
                return
            }
            
            // Decodificación
            do {
                let response = try JSONDecoder().decode(BookResponse.self, from: data)
                completion(response.results)
            } catch {
                print("🔴 Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
}


struct BookResponse: Codable {
    let count: Int          // Número total de libros disponibles
    let next: String?      // URL para la siguiente página (paginación)
    let previous: String?  // URL para la página anterior
    let results: [Book]    // Array de libros
    
    // Tip: Puedes omitir 'count', 'next' y 'previous' si no los necesitas
}
