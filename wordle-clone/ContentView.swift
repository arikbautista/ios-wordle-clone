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
