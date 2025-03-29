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
        var urlString = baseURL
        if let query = searchQuery {
            urlString += "?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct BookResponse: Codable {
    let results: [Book]
}
