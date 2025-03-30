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
    func fetchBookDescription(title: String, author: String, completion: @escaping (String?) -> Void) {
        let queryTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://openlibrary.org/search.json?title=\(queryTitle)&author=\(queryAuthor)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let docs = json["docs"] as? [[String: Any]],
                   let firstDoc = docs.first,
                   let description = firstDoc["first_sentence"] as? [String] {
                    completion(description.joined(separator: " "))
                } else {
                    completion(nil)
                }
            } catch {
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
