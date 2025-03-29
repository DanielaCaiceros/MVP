//
//  DialogBoxView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI

struct DialogBoxView: View {
    @State public var message: String
    var body: some View {
        Text(message)
            .padding()
            .background(mainColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(45))
                    .offset(x: -10, y : 10)
                    .foregroundStyle(mainColor)
            }
    }
}

#Preview {
    DialogBoxView(message: "Hello!")
}
