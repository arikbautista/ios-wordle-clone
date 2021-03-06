//
//  KeyboardView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-27.
//

import SwiftUI

struct KeyboardView:View {
    @ObservedObject var boardData : BoardData
    
    let topRowKeys = "QWERTYUIOP".map{String($0)}
    let middleRowKeys = "ASDFGHJKL".map{String($0)}
    let bottomRowKeys = "ZXCVBNM".map{String($0)}
    
    let enterKeyText = "Enter"
    let delKeyText = "Del"
    
    init(boardData: BoardData) {
        self.boardData = boardData
    }
    
    var body: some View {
        VStack {
            KeyboardRow(letterArray: topRowKeys, boardData: boardData)
            KeyboardRow(letterArray: middleRowKeys, boardData: boardData)
            HStack {
                Spacer()
                Text(enterKeyText).onTapGesture(perform: {
                    let isWordFull = boardData.currentGuess.count == boardData.wordLength
                    let isMaxGuess = boardData.guessArray.count > boardData.numOfRows
                    let isCorrectGuess = boardData.currentGuess.uppercased() == boardData.correctWord.uppercased()
                    
                    if (!isWordFull || isMaxGuess) {
                        return
                    }

                    boardData.guessArray.append(boardData.currentGuess)
                    boardData.currentGuess = ""
                    
                    if (isCorrectGuess || boardData.guessArray.count == boardData.numOfRows){
                        boardData.hasFinishedGame = true
                    }
                })
                
                KeyboardRow(letterArray: bottomRowKeys, boardData: boardData)
                
                Text(delKeyText)
                .onTapGesture(perform: {
                    boardData.currentGuess = String(boardData.currentGuess.dropLast())
                })
                Spacer()
            }
        }
    }
}

struct KeyboardRow: View {
    @ObservedObject var boardData : BoardData
    var letterArray: Array<String>
    
    init(letterArray: Array<String>, boardData: BoardData) {
        self.letterArray = letterArray
        self.boardData = boardData
    }
    
    var body: some View {
        HStack {
            ForEach(letterArray, id: \.self) { letter in
                
                let letterColor: Color = boardData.usedLetters[letter.uppercased()] ?? Color.white
                
                Text(letter)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                    .padding(.vertical)
                    .frame(maxWidth: 32)
                    .frame(maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(letterColor)
                        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    )
                    .onTapGesture(perform: {
                        
                        let canInput = boardData.currentGuess.count >= boardData.wordLength || boardData.hasFinishedGame
                        if (canInput) {
                            return
                        }
                        
                        boardData.currentGuess += letter
                    })
            }
        }
    }
}
