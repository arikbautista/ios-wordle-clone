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
        ZStack {
            MainGameBoardView(globalBoardData: globalBoardData)
            if (globalBoardData.hasFinishedGame) {
                FinishGameMessageView(boardData: globalBoardData)
            }
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

struct MainGameBoardView: View {
    @ObservedObject var globalBoardData: BoardData
    
    init(globalBoardData : BoardData) {
        self.globalBoardData = globalBoardData
    }
    
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

struct FinishGameMessageView: View {
    @ObservedObject var boardData : BoardData
    
    init(boardData : BoardData) {
        self.boardData = boardData
    }
    
    var body: some View {
        VStack {
            Text(self.boardData.getFinishGameMessage())
                .position(x: UIScreen.screenWidth / 2, y: 85)
                .font(.headline)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.gray)
                        .frame(width: 185, height: 45)
                        .position(x: UIScreen.screenWidth / 2, y: 85)
                )
                .foregroundColor(.white)
        }
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
