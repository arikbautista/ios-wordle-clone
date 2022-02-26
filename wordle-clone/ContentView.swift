//
//  ContentView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-23.
//

import SwiftUI

class BoardData: ObservableObject {
    @Published var guessArray: [String] = []
    @Published var currentGuess = ""
    
    @Published var wordLength = 5
    @Published var numOfRows = 6
}

struct ContentView: View {
    @StateObject var globalBoardData = BoardData()
    
    var body: some View {
        VStack {
            //Banner
            BannerView()
            
            // Letter Grid
            ForEach(0 ..< globalBoardData.numOfRows) { rowIndex in
                
                if (rowIndex == globalBoardData.guessArray.count ) {
                    RowView(numOfLetters: globalBoardData.wordLength, rowGuess: globalBoardData.currentGuess)
                } else {
                    let curGuessRow = rowIndex > globalBoardData.guessArray.count
                        ? ""
                        : globalBoardData.guessArray[rowIndex]
                    RowView(numOfLetters: globalBoardData.wordLength, rowGuess: curGuessRow)
                }
            }
            Spacer()
            
            KeyboardView(boardData: globalBoardData)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
        }
    }
}

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

struct KeyboardView:View {
    @ObservedObject var boardData : BoardData
    
    let topRowKeys = "QWERTYUIOP".map{String($0)}
    let middleRowKeys = "ASDFGHJKL".map{String($0)}
    let bottomRowKeys = "ZXCVBNM".map{String($0)}
    
    let enterKeyText = "Enter"
    let delKeyText = "Del"
    
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

struct BannerView:View {
    var body: some View {
        ZStack {
            Text("Arik's Wordle Clone")
                .font(.title3)
                .fontWeight(.heavy)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            
        }
    }
}
