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
    
    @Published var correctWord = "Cliff"
    
    // Key: letter used
    // Value: the color that should be represented on the keyboard
    @Published var usedLetters: [String : Color] = [:]
    
    func calculateWordColors(word: String) -> [Color] {
        var colorResult : [Color] = []
        var correctWordAsDict = mapWordToDict(word: self.correctWord)
        let wordAsArray = word.map{String($0).uppercased()}
        
        // We need to keep track of the yellow letters in case we have to change it
        // to gray
        // Key: letter that is yello
        // Value: set of indexes within the guessed word
        var yellowLetterIndicies : [String : Set<Int>] = [:]
        
        var index = 0
        while (index < self.wordLength) {
            
            let curLetter = index > wordAsArray.count - 1
                ? ""
                : wordAsArray[index]
            let curIndexSet = correctWordAsDict[curLetter]
            
            let isSetEmptyOrNull : Bool = curIndexSet?.isEmpty ?? true
            if ( isSetEmptyOrNull || curLetter == "") {
                colorResult.append(Color.gray)
                index += 1
                continue
            }
            
            let isInRightSpot : Bool = curIndexSet?.contains(index) ?? false
            
            if (isInRightSpot) {
                correctWordAsDict[curLetter]?.remove(index)
                
                // If this letter is correctly guessed in all places
                // then any yellow ones of this letter need to be changed to gray.
                if (curIndexSet?.count == 1) {
                    let indexChangeToGray : [Int] = yellowLetterIndicies[curLetter]?.map{Int($0)} ?? []
                    
                    for index in indexChangeToGray {
                        colorResult[index] = Color.gray
                    }
                }
                
                colorResult.append(Color.green)
            } else {
                colorResult.append(Color.yellow)
                
                if (yellowLetterIndicies[curLetter] == nil) {
                    yellowLetterIndicies[curLetter] = [index]
                } else {
                    yellowLetterIndicies[curLetter]?.insert(index)
                }
            }
            
            
            index += 1
        }
        return colorResult
    
    }
    
    func mapWordToDict(word: String) -> [String: Set<Int>] {
        // This function takes in a word and returns a dictionary
        // where the keys are the letters in the word
        // and the value is set of ints representing the index of
        // those letters in the word
        var result : [String: Set<Int>] = [:]
        let wordAsArray = word.map{String($0).uppercased()}
        
        for index in wordAsArray.indices {
            let currentLetter = wordAsArray[index]
            if (result[currentLetter] == nil) {
                result[currentLetter] = [index]
            } else {
                result[currentLetter]?.insert(index)
            }
        }
        
        return result
    }
    
}

struct ContentView: View {
    @StateObject var globalBoardData = BoardData()
    
    
    var body: some View {
        VStack {
            //Banner
            BannerView()
            
            //RowView(boardData: globalBoardData, rowGuess: "", isCurrentGuess: false)

            
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
