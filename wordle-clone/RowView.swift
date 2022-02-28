//
//  RowView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-27.
//

import SwiftUI

struct RowView:View {
    @ObservedObject var boardData: BoardData
    var rowGuess: String
    var isCurrentGuess: Bool
    var rowGuessAsArray : [String]
    var wordColors : [Color]

    
    init(boardData: BoardData, rowGuess: String, isCurrentGuess: Bool) {
        self.boardData = boardData
        // Split word up into individual letters.
        self.rowGuess = isCurrentGuess && rowGuess == "" ? boardData.currentGuess : rowGuess
        self.isCurrentGuess = isCurrentGuess
        self.rowGuessAsArray = self.rowGuess.map{String($0)}
        
        self.wordColors = !isCurrentGuess
            ? boardData.calculateWordColors(word: self.rowGuess)
            : boardData.calculateWordColors(word: "") // defaults to all gray.
    }
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(0 ..< boardData.wordLength) { index in
                let curLetter = index > rowGuessAsArray.count - 1
                    ? ""
                    : rowGuessAsArray[index]
                
                Text(curLetter)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .padding(.vertical, 10.0)
                .frame(maxWidth: 55)
                .frame(maxHeight: 55)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(wordColors[index])
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                ).onAppear(perform: {
                    if (curLetter != "") {
                        boardData.updateUsedLetters(letter: curLetter, color: wordColors[index])
                    }
                })

            }
            Spacer()
        }
    }
}
