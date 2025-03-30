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
            
            Text("You read")
                .font(.title2)
            HStack{
                Image(systemName: "book")
                    .font(.system(size: 35))
                Text("\(wordAmount) words")
                    .font(.system(size: 39))
            }
            .bold()
            
            .foregroundStyle(mainColor)
           
            Text("in")
                .font(.title2)
            let totalTime = "\(minutes):" + formatSeconds(s: seconds) + " minutes"
            HStack{
                Image(systemName: "timer")
                    .font(.system(size: 35))
                Text(totalTime)
                    .font(.system(size: 39))
            }
            .bold()
            .font(.title)
            
            .foregroundStyle(mainColor)
            
            Spacer()
            
            Button{
                print("Continue")
            } label: {
                Text("Continue reading")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .background(mainColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(mainColor)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }

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
