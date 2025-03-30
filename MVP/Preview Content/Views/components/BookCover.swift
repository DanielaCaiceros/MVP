//
//  BookCover.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//


import SwiftUI
import Kingfisher

struct BookCover: View {
    let imageURL: URL?
    
    var body: some View {
        Group {
            if let url = imageURL {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
    }
}