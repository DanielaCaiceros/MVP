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
    
    func printAvailableFormats() {
            guard let formats = formats else {
                print("Este libro no tiene formatos registrados.")
                return
            }
            print("--- Formatos disponibles para '\(title)' ---")
            for (key, value) in formats {
                print("\(key): \(value)")
            }
        }
    
    struct Author: Codable {
        let name: String
        let birthYear: Int?
        let deathYear: Int?
    }
    
    // URL del libro en texto plano (prioridad) o ePub
    var textFileURL: URL? {
        guard let formats = formats else { return nil }
        
        // Orden de prioridad:
        let preferredFormats = [
            "text/plain",       // Primero texto plano simple
            "text/plain;",      // Variantes (charset=utf-8, us-ascii, etc.)
            "text/html",        // HTML como alternativa
            "application/epub+zip" // EPUB (requiere librería externa)
        ]
        
        for format in preferredFormats {
            for (key, value) in formats {
                if key.hasPrefix(format) {
                    return URL(string: value)
                }
            }
        }
        
        return nil
    }

}
