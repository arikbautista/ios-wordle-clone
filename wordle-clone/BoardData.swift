//
//  BoardData.swift
//  wordle-clone
//
//  Created by Arik Bautista on 2022-02-27.
//
import SwiftUI

class BoardData: ObservableObject {
    @Published var guessArray: [String] = []
    @Published var currentGuess = ""
    
    @Published var wordLength = 5
    @Published var numOfRows = 6
    
    @Published var correctWord = "rhyme"
    
    @Published var hasFinishedGame : Bool = false
    
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
                // White is default.
                colorResult.append(curLetter == "" ? Color.white : Color.gray)
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
    
    func updateUsedLetters(letter: String, color: Color) -> Void {
        let letter = letter.uppercased()
        if (letter == "") {
            return
        }
        let lastColorOfLetter : Color = usedLetters[letter] ?? Color.gray
        if ( lastColorOfLetter == Color.gray) {
            usedLetters.updateValue(color, forKey: letter)
        }
        
        if ( lastColorOfLetter == Color.yellow && color != Color.gray) {
            usedLetters.updateValue(color, forKey: letter)
        }
        
    }
    
    func getFinishGameMessage() -> String{
        // Messages are only configured for 6 guesses.
        if (self.guessArray.last?.uppercased() != self.correctWord.uppercased()) {
            return "Better luck next time"
        }
        
        let numOfGuesses = self.guessArray.count
        
        switch numOfGuesses {
        case 1:
            return "Cheater"
        case 2:
            return "Lucky"
        case 3:
            return "Genius"
        case 4:
            return "Great"
        case 5:
            return "Not bad"
        case self.numOfRows:
            return "Close Call"
        default:
            return "Nice" // if we have more than 6 guesses
        }
    }
    
}
