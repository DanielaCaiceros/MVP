//
//  MetadataRow.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

import SwiftUICore


// En MetadataRow.swift
struct MetadataRow: View { // Añadir conformancia con View
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
            Text(text)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
