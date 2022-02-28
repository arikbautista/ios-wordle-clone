//
//  ContentView.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var globalBoardData = BoardData()
    
    var body: some View {
        VStack {
            //Banner
            BannerView()
            Spacer()
            
            // Letter Grid
            ForEach(0 ..< globalBoardData.numOfRows) { rowIndex in
                
                if (rowIndex == globalBoardData.guessArray.count ) {
                    RowView(boardData: globalBoardData, rowGuess: "", isCurrentGuess: true)
                } else {
                    let curGuessRow = rowIndex > globalBoardData.guessArray.count
                        ? ""
                        : globalBoardData.guessArray[rowIndex]
                    RowView(boardData: globalBoardData, rowGuess: curGuessRow, isCurrentGuess: false)
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
