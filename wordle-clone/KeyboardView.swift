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
                
                Text(enterKeyText).onTapGesture(perform: {
                    let isWordFull = boardData.currentGuess.count == boardData.wordLength
                    let isMaxGuess = boardData.guessArray.count > boardData.numOfRows
                    
                    if (!isWordFull || isMaxGuess) {
                        return
                    }
                    
                    boardData.guessArray.append(boardData.currentGuess)
                    boardData.currentGuess = ""
                })
                
                KeyboardRow(letterArray: bottomRowKeys, boardData: boardData)
                
                Text(delKeyText)
                .onTapGesture(perform: {
                    boardData.currentGuess = String(boardData.currentGuess.dropLast())
                })
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
                Text(letter)
                    .padding(.vertical)
                    .frame(width: 24, height: 30)
                    .cornerRadius(16)
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .onTapGesture(perform: {
                        if (boardData.currentGuess.count  >= boardData.wordLength) {
                            return
                        }
                        
                        boardData.currentGuess += letter
                    })
            }
        }
    }
}
