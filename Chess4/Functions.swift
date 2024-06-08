//
//  Functions.swift
//  Chess4
//
//  Created by William Becht on 5/5/22.
//

import Foundation
import SwiftUI

// converts "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" to locationArray
func convertFenToLocationArray(fenLine: String) -> [[String]] {
    var locationArray = [[String]]()
    let spaceIndex = fenLine.index(before: fenLine.firstIndex(of: " ")!)
    let cutString = String(fenLine[...spaceIndex])
    let fenRows = cutString.components(separatedBy: "/")

    var skipVal = 0
    var color = ""
    var piece = ""
    for fenRow in fenRows {  // fenrow: rnbqkbnr
        var stringList = [String]()
        for charVal in fenRow { // charVal: "r" or "8"
            if charVal.isNumber {
                skipVal = Int(charVal.wholeNumberValue!)
                for _ in 1...skipVal {
                    stringList.append("")
                }
            } else {
                if charVal.isLowercase {
                    color = "b"
                } else {
                    color = "w"
                }
                piece = charVal.lowercased()
                let pieceName = color+piece
                stringList.append(pieceName)
            }
        }
        locationArray.append(stringList)
    }
    return locationArray
}


func findPuzzle(rating: Int, puzzleList: [Puzzle]) -> Puzzle {
    var diff = 1000
    var closestPuzzle = Puzzle()
    for puzzle in puzzleList {
        if abs(rating - puzzle.rating) < diff {
            if !usedPuzzleIds.contains(puzzle.id) {
                diff = abs(rating - puzzle.rating)
                closestPuzzle = puzzle
            }
        }
    }
    return closestPuzzle
}


func initReferenceDict() -> [CGFloat:CGFloat] {
    var refDict = [CGFloat:CGFloat]()
    var total = 0
    for _ in 1...64{
        refDict[CGFloat(total)] = 0.0
        total += 1
        if total % 10 > 7 {
            total += 2
        }
    }
    return refDict
}


func convertFenToLocDict(fen:String) -> [CGFloat:String] {
    let locArray = convertFenToLocationArray(fenLine: fen)
    let locDict = convertLocationArrayToDict(locationArray: locArray)
    return locDict
}


func convertLocationArrayToDict(locationArray: [[String]]) -> [CGFloat:String] {
    var locDict = [CGFloat:String]()
    var total = 0
    for i in 0 ..< locationArray.count {
        for j in 0 ..< locationArray[i].count {
            locDict[CGFloat(total)] = locationArray[i][j]
            total += 1
            if total % 10 > 7 {
                total += 2
            }
        }
    }
    return locDict
}


func readPuzzleFile(filename: String) -> [Puzzle] {
    if filename == "" {
        return [Puzzle()]
    }
    var fileLines = [String]()
    if let path = Bundle.main.path(forResource: filename, ofType: "txt"){
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            fileLines = data.components(separatedBy: .newlines)
        } catch {
            fileLines = ["Error reading puzzle text file"]
        }
    }
    fileLines = fileLines.filter {!$0.isEmpty}
    
    var puzzleList = [Puzzle]()
    for eachLine in fileLines {
        let puzzleParams = eachLine.components(separatedBy: ",")
        puzzleList.append(Puzzle(id: puzzleParams[0], fen: puzzleParams[1], moveList: puzzleParams[2].components(separatedBy: " "), rating: Int(puzzleParams[3])!, ratingDeviation: Int(puzzleParams[4])!, popularity: Int(puzzleParams[5])!, nbPlays: Int(puzzleParams[6])!, themes: puzzleParams[7], gameURL: puzzleParams[8]))
    }
    return puzzleList
}
