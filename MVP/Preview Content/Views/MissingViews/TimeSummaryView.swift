//
//  TimeSummaryView.swift
//  MVP
//
//  Created by Leo A.Molina on 29/03/25.
//

import SwiftUI

struct TimeSummaryView: View {
    @State public var wordAmount: Int
    @State public var minutes: Int
    @State public var seconds: Int
    
    var body: some View {
        VStack(alignment: .center){
            Text("Reading speed summary")
                .font(.title)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .bold()
            
            Spacer()
            
            Text("You have read")
                .font(.title2)
            HStack{
                Image(systemName: "book")
                Text("\(wordAmount) words")
            }
            .bold()
            .font(.title)
            .foregroundStyle(mainColor)
           
            Text("in")
                .font(.title2)
            HStack{
                Image(systemName: "book")
                
                Text("hello")
            }
            .bold()
            .font(.title)
            .foregroundStyle(mainColor)
            
            Spacer()
            
        }
        .padding()
    }
}

func formatSeconds(s: Int) -> String {
    if s < 10{
        return "0\(s)"
    } else{
        return "\(s)"
    }
}

#Preview {
    TimeSummaryView(wordAmount: 200, minutes: 243, seconds: 53)
}
