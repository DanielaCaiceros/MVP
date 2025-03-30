//
//  SectionHeader.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//
import SwiftUICore
import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .padding(.vertical, 8)
    }
}
