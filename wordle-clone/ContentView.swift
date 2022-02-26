//
//  ContentView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-23.
//

import SwiftUI

class BoardData: ObservableObject {
    @Published var guessArray: [String] = ["CHORE", "CRANE"]
    @Published var currentGuess = "Sli"
}

struct ContentView: View {
    @StateObject var globalBoardData = BoardData()
    var numOfRows = 6
    
    var body: some View {
        VStack {
            //Banner
            BannerView()
            
            // Letter Grid
            ForEach(0 ..< numOfRows) { rowIndex in
                
                if (rowIndex == globalBoardData.guessArray.count ) {
                    RowView(numOfLetters: 5, rowGuess: globalBoardData.currentGuess)
                } else {
                    let curGuessRow = rowIndex > globalBoardData.guessArray.count
                        ? ""
                        : globalBoardData.guessArray[rowIndex]
                    RowView(numOfLetters: 5, rowGuess: curGuessRow)
                }
            }
            Spacer()
            
            KeyboardView()
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
    let topRowKeys = "QWERTYUIOP".map{String($0)}
    let middleRowKeys = "ASDFGHJKL".map{String($0)}
    let bottomRowKeys = "ZXCVBNM".map{String($0)}
    
    let enterKeyText = "Enter"
    let delKeyText = "Del"
    
    var body: some View {
        VStack {
            KeyboardRow(letterArray: topRowKeys)
            KeyboardRow(letterArray: middleRowKeys)
            HStack {
                Text(enterKeyText)
                KeyboardRow(letterArray: bottomRowKeys)
                Text(delKeyText)
            }
        }
    }
}

struct KeyboardRow: View {
    var letterArray: Array<String>
    
    init(letterArray: Array<String>) {
        self.letterArray = letterArray
    }
    
    var body: some View {
        HStack {
            ForEach(letterArray, id: \.self) { letter in
                Text(letter)
                    .padding(.vertical)
                    .frame(width: 24, height: 30)
                    .cornerRadius(16)
                    .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
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

func updateCurrentGuess(letterToUpdate: String ) -> Void {
    /*@ObservedObject var globalBoardData : BoardData
    
    if (letterToUpdate == "") {
        globalBoardData.$currentGuess.dropLast()
    }*/
}
