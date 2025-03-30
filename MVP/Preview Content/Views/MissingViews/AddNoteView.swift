//
//  AddNoteView.swift
//  MVP
//
//  Created by Leo A.Molina on 30/03/25.
//

import SwiftUI

struct AddNoteView: View {
    @State private var text: String = ""
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text("I think that...")
            .font(.title)
            .foregroundStyle(mainColor)
            .fontWeight(.bold)
           TextEditor(text: $text)
               .submitLabel(.done)
               .frame(height: 100, alignment: .top)
               .lineLimit(3)
               .cornerRadius(22)
               .multilineTextAlignment(.leading)
               .colorMultiply(Color(.systemGray5))
           }
           .frame(minWidth: 0, maxWidth: .infinity)
           .padding(.horizontal)
    }
}

#Preview {
    AddNoteView()
}
