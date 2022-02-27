//
//  RowView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-27.
//

import SwiftUI

struct RowView:View {
    var numOfLetters: Int
    var rowGuess: Array<String>
    
    init(numOfLetters: Int, rowGuess: String) {
        self.numOfLetters = numOfLetters
        
        // Split word up into individual letters.
        self.rowGuess = rowGuess.map{String($0)}
    }
    
    var body: some View {
        HStack {
            ForEach(0 ..< numOfLetters) { num in
                let curLetter = num > rowGuess.count - 1
                    ? ""
                    : rowGuess[num]
                
                Text(curLetter)
                .textCase(.uppercase)
                .padding(.vertical, 10.0)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                )
            }
        }
    }
}
