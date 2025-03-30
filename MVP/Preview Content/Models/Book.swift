//
//  Book.swift
//  MVP
//
//  Created by Daniela Caiceros on 29/03/25.
//

import Foundation

struct Book: Identifiable, Codable {
    let id: Int
    let title: String
    let authors: [Author]?
    let languages: [String]?
    let formats: [String: String]?
    let downloadCount: Int?
    
    struct Author: Codable {
        let name: String
        let birthYear: Int?
        let deathYear: Int?
    }
    
    var textFileURL: URL? {
        guard let formats = formats else { return nil }
        
        // Formatos prioritarios en orden
        let preferredFormats = [
            "text/plain",
            "text/plain; charset=utf-8",
            "text/plain; charset=us-ascii",
            "text/html"
        ]
        
        // Busca el primer formato disponible
        for format in preferredFormats {
            if let urlString = formats[format],
               let url = URL(string: urlString) {
                return url
            }
        }
        
        // Si no encuentra los prioritarios, busca cualquier clave que comience con "text/plain"
        if let (_, urlString) = formats.first(where: { $0.key.hasPrefix("text/plain") }),
           let url = URL(string: urlString) {
            return url
        }
        
        return nil
    }
}
