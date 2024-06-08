//
//  GameScene.swift
//  Chess
//
//  Created by William Becht on 3/2/22.
//

import SpriteKit
//import GameplayKit
//import SwiftUI
//import Foundation

class GameScene: SKScene {
    
    
    var moveDelay = 0.5
    var filenames = curFileList //["london1_output"]
    let labelVal = curTitle
    var doneLabel = SKLabelNode(fontNamed: "Times New Roman")
    var moveNumberLabel = SKLabelNode(fontNamed: "Times New Roman")
    var titleLabel = SKLabelNode(fontNamed: "Times New Roman")
    var board = SKSpriteNode(imageNamed: "board_green")
    var continueButton = SKSpriteNode(imageNamed: "continueButton")
    var resetButton = SKSpriteNode(imageNamed: "resetButton")
    var backButton = SKSpriteNode(imageNamed: "backButton")
    var nextMoveListButton = SKSpriteNode(imageNamed: "forwardButton")
    var backMoveListButton = SKSpriteNode(imageNamed: "backwardButton")
    var menuButton = SKSpriteNode(imageNamed: "menuButton")
    var greenCircle = SKSpriteNode(imageNamed: "greenCircle")
    var redCircle = SKSpriteNode(imageNamed: "redCircle")
    var greenBorder = SKSpriteNode(imageNamed: "greenBorder")
    var correct = SKSpriteNode(imageNamed: "correct")
    var incorrect = SKSpriteNode(imageNamed: "incorrect")
    var firstTouch = CGPoint()
    var nextTouch = CGPoint()
    var needToTouch = true
    var selectedPiece = [String]()
    var pieceSelected = false
    var numWhiteMoves = 0
    var numBlackMoves = 0
    var listNumber = chosenLevel
    var fenLines = [String]()
    var fenLinesList = [[String]]()
    var moveList = [String]()
    var whiteMoveList = [String]()
    var blackMoveList = [String]()
    var prevLocationArray = [[String]]()
    var result = "nothing"
    var moveNumber = 0
    var setup = false
    var tapNumber = -1
    
    
    var nodeTouched = SKNode()
    var stringArray: [[String]] = [
        ["a8", "b8", "c8", "d8", "e8","f8", "g8", "h8"],
        ["a7", "b7", "c7", "d7", "e7","f7", "g7", "h7"],
        ["a6", "b6", "c6", "d6", "e6","f6", "g6", "h6"],
        ["a5", "b5", "c5", "d5", "e5","f5", "g5", "h5"],
        ["a4", "b4", "c4", "d4", "e4","f4", "g4", "h4"],
        ["a3", "b3", "c3", "d3", "e3","f3", "g3", "h3"],
        ["a2", "b2", "c2", "d2", "e2","f2", "g2", "h2"],
        ["a1", "b1", "c1", "d1", "e1","f1", "g1", "h1"],
      ]
    
    var originalSetup: [[String]] = [
        ["br", "bn", "bb", "bq", "bk","bb", "bn", "br"],
        ["bp", "bp", "bp", "bp", "bp","bp", "bp", "bp"],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["wp", "wp", "wp", "wp", "wp","wp", "wp", "wp"],
        ["wr", "wn", "wb", "wq", "wk","wb", "wn", "wr"],
      ]
    var curLocationArray = [
        ["br", "bn", "bb", "bq", "bk","bb", "bn", "br"],
        ["bp", "bp", "bp", "bp", "bp","bp", "bp", "bp"],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["wp", "wp", "wp", "wp", "wp","wp", "wp", "wp"],
        ["wr", "wn", "wb", "wq", "wk","wb", "wn", "wr"],
      ]
    
    var letterDict = ["a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7]
    
    func convertStringLocationToIndex(stringLocation: String) -> [Int] {
        let letter = stringLocation[0]
        let col = letterDict[String(letter)]!
        let row = 8 - Int(stringLocation[1].wholeNumberValue!)
        return [row,col]
    }
    
    func convertToNumMoveList(strMoveList: [[String]]) -> [[Int]] {
        var numList = [[Int]]()
        for curMove in strMoveList {
            let origLoc = curMove[0]
            let newLoc = curMove[1]
            
            let origRowCol = convertStringLocationToIndex(stringLocation: origLoc)
            let newRowCol = convertStringLocationToIndex(stringLocation: newLoc)
            numList.append([origRowCol[0],origRowCol[1],newRowCol[0],newRowCol[1]])
        }
        return numList
    }
    
    // returns "a1" as its CGPoints
    func calculateSquareLocFromName(name: String) -> CGPoint {
        let boardSize = boardMult2*frame.width
        let rowCol = convertStringLocationToIndex(stringLocation: name) // ex: [7,0]
        let inValx = boardSize*(-7/16)
        let inValy = boardSize*(7/16)
        let x = inValx+Double(rowCol[1])*(boardSize/8)
        let y = inValy-Double(rowCol[0])*(boardSize/8)
        return CGPoint(x: x, y: y)
    }

    // returns CGPoint as ["a1","wr1"]
    func calculateSquareLocation(point: CGPoint,locationArray: [[String]]) -> [String] {
        let boardSize = boardMult2*frame.width
        let xval = point.x
        let yval = -point.y
        if abs(xval) > boardSize/2 || abs(yval) > boardSize/2 {
            return ["invalid","invalid"]
        }
        var inValx = xval/(boardSize/8)
        var inValy = yval/(boardSize/8)
        
        
        inValx = inValx + 4.0
        inValy = inValy + 4.0
        
        let col = Int(floor(abs(inValx)))
        let row = Int(floor(abs(inValy)))
        
        
        let squareInfo = [stringArray[row][col], locationArray[row][col]]
        return squareInfo
    }
    
    
    func isMoveAllowed(pieceName: String,startLocation: String,endLocation: String,locationArray: [[String]],moving: Bool) -> Bool {
        let color = String(pieceName[0]) // ex: "w" or "b"
        let pieceIdentifier = String(pieceName[1]) // ex: "r" for rook
        let startSquare = convertStringLocationToIndex(stringLocation: startLocation) // ex: [7,0]
        let endSquare = convertStringLocationToIndex(stringLocation: endLocation) // ex: [7,0]
        let capturedPiece = locationArray[endSquare[0]][endSquare[1]] // ex: "wr"
        var capColor = ""
        
        if !capturedPiece.isEmpty {
            capColor = String(capturedPiece[0])
        }

        if startSquare == endSquare || pieceName == "" || color == capColor {
            return false
        }
        
        let jumpVerticalDistance = endSquare[0] - startSquare[0]
        let jumpHorzDistance = endSquare[1] - startSquare[1]
        
        /*
        // for white pieces
        if (pieceIdentifier == "q" || pieceIdentifier == "b") && moving {
            if abs(jumpVerticalDistance) > 1 && abs(jumpHorzDistance) > 1 {
                var squaresCrossed = [[Int]]()
                let left = (endSquare[1] - startSquare[1]) < 0
                let right = !left
                let up = (endSquare[0] - startSquare[0]) < 0
                let down = !up
                
                if left && up {
                    var curSquare = startSquare
                    while curSquare != endSquare {
                        
                    }
                } else if left && down {
                    
                } else if right && up {
                    
                } else if right && down {
                    
                }
                
                
            }
        }*/
        
        
        
        // making sure pieces (other than knight) don't jump over each other
        // diagonal movements
        /*
        if pieceIdentifier == "q" || pieceIdentifier == "b" {
            if abs(jumpVerticalDistance) > 1 && abs(jumpHorzDistance) > 1 {
                var squaresCrossed = [[Int]]()
                let left = (endSquare[1] - startSquare[1]) < 0
                let right = !left
                let up = (endSquare[0] - startSquare[0]) < 0
                let down = !up
                let numRowsToCheck = Int(ceil(Double((abs(startSquare[0]-endSquare[0])))/2.0))
                for _ in 1...numRowsToCheck {
                    if up && left {
                        squaresCrossed.append([startSquare[0]-1,startSquare[1]-1])
                    } else if down && left {
                        squaresCrossed.append([startSquare[0]+1,startSquare[1]-1])
                    } else if up && right {
                        squaresCrossed.append([startSquare[0]-1,startSquare[1]+1])
                    } else if down && right {
                        squaresCrossed.append([startSquare[0]+1,startSquare[1]+1])
                    }
                }
                if moving {
                    print(numRowsToCheck.description)
                }
                for eachSquare in squaresCrossed {
                    if eachSquare[0] < 8 && eachSquare[0] > -1 && eachSquare[1] < 8 && eachSquare[1] > -1 {
                        if curLocationArray[eachSquare[0]][eachSquare[1]] == "" {
                            return false
                        }
                    }
                }
            }
        }
         */
        // lateral movements
        if pieceIdentifier == "q" || pieceIdentifier == "r" {
            if abs(jumpVerticalDistance) > 1 && abs(jumpHorzDistance) > 1 {
                
            }
        }
        
        // Need:
        // pawn: test en passant, queening
        // queen: stop jumping over pieces
        // bishop: stop jumping over pieces
        // rook: stop jumping over pieces
        // king: should be done
        // knight: should be done
        

        switch pieceIdentifier {
        case "p":
            //print("pawn")
            // en passant rules
            if color == "w" && startSquare[0] == 3 && endSquare[0] == 2 {
                if abs(jumpVerticalDistance) == 1 && abs(jumpHorzDistance) == 1 && capturedPiece == "" {
                    if moving {
                        curLocationArray[endSquare[0]+1][endSquare[1]] = ""
                    }
                    return true
                }
            } else if color == "b" && startSquare[0] == 4 && endSquare[0] == 5 {
                if abs(jumpVerticalDistance) == 1 && abs(jumpHorzDistance) == 1 && capturedPiece == "" {
                    if moving {
                        curLocationArray[endSquare[0]-1][endSquare[1]] = ""
                    }
                    return true
                }
            }
            
            // don't allow capture of pawn to the front
            if capturedPiece != "" {
                if color != capColor && abs(jumpHorzDistance) == 0 && abs(jumpVerticalDistance) > 0 {
                    return false
                }
            }
            
            // don't allow backward or side to side pawn movement
            if color == "w" && startSquare[0] - endSquare[0] < 1 {
                return false
            } else if color == "b" && jumpVerticalDistance < 1 {
                return false
            }
            
            // forward pawn movement at start
            let allowJumpW = color == "w" && startSquare[0] == 6
            let allowJumpB = color == "b" && startSquare[0] == 1
            if !allowJumpW && !allowJumpB && (abs(jumpVerticalDistance) > 1) {
                return false
            }
            // limiting movement
            if abs(jumpVerticalDistance) > 2 || abs(jumpHorzDistance) > 1 {
                return false
            } else if abs(jumpVerticalDistance) > 1 && abs(jumpHorzDistance) > 0 {
                return false
            }
            
            //diagonal movement
            if abs(jumpVerticalDistance) == 1 && abs(jumpHorzDistance) == 1 {
                if capturedPiece == "" {
                    return false
                }
                if color == "w" && capColor != "b" {
                    return false
                }
                if color == "b" && capColor != "w" {
                    return false
                }
            }
            
        case "r":
            //print("rook")
            // cannot move diagonally
            if startSquare[0] != endSquare[0] && startSquare[1] != endSquare[1] {
                return false
            }
        case "n":
            //print("knight")
            // only allow L-shaped movement
            if abs(jumpVerticalDistance) != 2 && abs(jumpVerticalDistance) != 1 {
                return false
            } else if abs(jumpHorzDistance) != 2 && abs(jumpHorzDistance) != 1 {
                return false
            } else if abs(jumpVerticalDistance) == abs(jumpHorzDistance) {
                return false
            }
        case "q":
            //print("queen")
            if startSquare[0] != endSquare[0] && startSquare[1] != endSquare[1] {
                if abs(jumpVerticalDistance) != abs(jumpHorzDistance) {
                    return false
                }
            }
        case "k":
            //print("king")
            // allow castling
            if color == "w" && startLocation == "e1" {
                if endLocation == "g1" && curLocationArray[7][7] == "wr" {
                    if curLocationArray[7][5] == "" && curLocationArray[7][6] == "" {
                        if moving {
                            curLocationArray[7][5] = "wr"
                            curLocationArray[7][7] = ""
                        }
                        return true
                    }
                } else if endLocation == "c1" && curLocationArray[7][0] == "wr" {
                    if curLocationArray[7][1] == "" && curLocationArray[7][2] == "" && curLocationArray[7][3] == "" {
                        if moving {
                            curLocationArray[7][3] = "wr"
                            curLocationArray[7][0] = ""
                        }
                        return true
                    }
                }
            } else if color == "b" && startLocation == "e8" {
                if endLocation == "g8" && curLocationArray[0][7] == "br" {
                    if curLocationArray[0][5] == "" && curLocationArray[0][6] == "" {
                        if moving {
                            curLocationArray[0][5] = "br"
                            curLocationArray[0][7] = ""
                        }
                        return true
                    }
                } else if endLocation == "c8" && curLocationArray[0][0] == "br" {
                    if curLocationArray[0][1] == "" && curLocationArray[0][2] == "" && curLocationArray[0][3] == "" {
                        if moving {
                            curLocationArray[0][3] = "br"
                            curLocationArray[0][0] = ""
                        }
                        return true
                    }
                }
            }
            
            // can only move one space (diagonally or laterally)
            if abs(jumpVerticalDistance) > 1 || abs(jumpHorzDistance) > 1 {
                return false
            }
        case "b":
            //print("bishop")
            if abs(jumpVerticalDistance) != abs(jumpHorzDistance) {
                return false
            }
        default:
            print("")
        }
        return true
    }
    
    // function that draws pieces on board according to locationArray
    func drawPieces(locationArray: [[String]]) {
        board.removeAllChildren()
        let boardSize = boardMult2*frame.width
        for index1 in 0...7 {
            for index2 in 0...7 {
                let item = locationArray[index1][index2]
                if item != "" {
                    let itemNode = SKSpriteNode(imageNamed: item)
                    itemNode.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
                    var y = boardSize*(7/16)
                    var x = boardSize*(-7/16)
                    x = x + ((boardSize*Double(index2))/8)
                    y = y - ((boardSize*Double(index1))/8)
                    itemNode.position = CGPoint(x: x, y: y)
                    board.addChild(itemNode)
            }
        }
        }
    }
    
    
    func readInFenText(filename: String) -> [String] {
        if filename == "" {
            return [""]
        }
        var fenLines = [String]()
        if let path = Bundle.main.path(forResource: filename, ofType: "txt"){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                //let myStrings = data.components(separatedBy: .newlines)
                //let text = myStrings.joined(separator: "\n")
                //fenLines = text.description
                fenLines = data.components(separatedBy: .newlines)
            } catch {
                fenLines = ["Error reading FEN text file"]
            }
        }
        fenLines = fenLines.filter {!$0.isEmpty}
        return fenLines
    }
    
    // converts "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" to locationArray
    func convertFenToLocationArray(fenLine: String) -> [[String]] {
        if fenLine == "" {
            return originalSetup
        }
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
    
    
    // called everytime the app moves to this view (startup view as of rn)
    override func didMove(to view: SKView) {
        // reading in text file
        for fn in filenames {
            fenLinesList.append(readInFenText(filename: fn))
        }
        
        // Creating board size and position; adding to screen
        let boardSize = boardMult2*frame.width
        let boardX = 0
        let boardY = 0
        board.position = CGPoint(x: boardX, y: boardY)
        board.size = CGSize(width: boardSize, height: boardSize)
        self.addChild(board)
        
        // adjusting button size and adding to screen
        continueButton.size = CGSize(width: continueButton.size.width * 0.6, height: continueButton.size.height*0.6)
        continueButton.position = CGPoint(x: boardSize/4, y: -boardSize/1.3)
        self.addChild(continueButton)
        
        backButton.size = CGSize(width: backButton.size.width * 0.21, height: backButton.size.height*0.21)
        backButton.position = CGPoint(x: -boardSize/4, y: -boardSize/1.3)
        self.addChild(backButton)
        
        resetButton.size = CGSize(width: resetButton.size.width * 0.35, height: resetButton.size.height*0.35)
        resetButton.position = CGPoint(x: 0, y: -boardSize/1.3)
        self.addChild(resetButton)
        
        
        redCircle.size = CGSize(width: redCircle.size.width * 0.2, height: redCircle.size.height*0.2)
        redCircle.position = CGPoint(x: 0, y: -boardSize/1.5)
        
        greenCircle.size = CGSize(width: greenCircle.size.width * 0.22, height: greenCircle.size.height*0.22)
        greenCircle.position = CGPoint(x: 0, y: -boardSize/1.5)
        
        greenBorder.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
        //greenBorder.position = CGPoint(x: -boardSize/16, y: -boardSize/2 + (boardSize/16))
        
        nextMoveListButton.size = CGSize(width: nextMoveListButton.size.width * 0.367, height: nextMoveListButton.size.height*0.367)
        nextMoveListButton.position = CGPoint(x: boardSize/8, y: boardSize/1.3)
        self.addChild(nextMoveListButton)
        
        backMoveListButton.size = CGSize(width: backMoveListButton.size.width * 0.265, height: backMoveListButton.size.height * 0.265)
        backMoveListButton.position = CGPoint(x: -boardSize/8, y: boardSize/1.3)
        self.addChild(backMoveListButton)
        
        if fenLinesList.isEmpty {
            moveNumberLabel.text = "Move: 0/0"
        } else {
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        }
        moveNumberLabel.fontSize = 20
        moveNumberLabel.position = CGPoint(x: -boardSize/2.4, y: -boardSize/1.8)
        self.addChild(moveNumberLabel)
        
        titleLabel.position = CGPoint(x: 0, y: boardSize/1.07)
        titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(fenLinesList.count) + ")"
        titleLabel.fontSize = 35
        self.addChild(titleLabel)
        
        doneLabel.fontSize = 30
        doneLabel.text = "DONE"
        doneLabel.position = CGPoint(x: 0, y: -boardSize/1.6)
        
        menuButton.size = CGSize(width: menuButton.size.width * 0.265, height: menuButton.size.height * 0.265)
        menuButton.position = CGPoint(x: -boardSize/2.4, y: boardSize/1.1)
        self.addChild(menuButton)
        
        correct.size = CGSize(width: correct.size.width * 0.15, height: correct.size.height * 0.15)
        correct.position = CGPoint(x: 0, y: boardSize/1.7)
        
        incorrect.size = CGSize(width: incorrect.size.width * 0.2, height: incorrect.size.height * 0.2)
        incorrect.position = CGPoint(x: 0, y: boardSize/1.7)
        
        
        // drawing initial setup of pieces
        drawPieces(locationArray: originalSetup)
    }
    
    
    func unselectPiece() {
        pieceSelected = false
        self.removeChildren(in: [greenBorder])
        resetButton.removeAllChildren()
    }
    
    func showPossibleMoves() {
        //selectedPiece = ["a1","wr"]
        let boardSize = boardMult2*frame.width
        for curRow in stringArray {
            for curItem in curRow {
                if isMoveAllowed(pieceName: selectedPiece[1], startLocation: selectedPiece[0], endLocation: curItem, locationArray: curLocationArray, moving: false) {
                    let endSquare = convertStringLocationToIndex(stringLocation: curItem) // ex: [7,0]
                    if curLocationArray[endSquare[0]][endSquare[1]] == "" {
                        let greyCircle = SKSpriteNode(imageNamed: "greyCircle")
                        greyCircle.size = CGSize(width: boardSize/16, height: boardSize/16)
                        greyCircle.alpha = 0.8 // alpha = 0.5 --> 50% transparent
                        let intendedPosition = calculateSquareLocFromName(name: curItem)
                        let adjustedPosition = CGPoint(x: intendedPosition.x - resetButton.position.x, y: intendedPosition.y - resetButton.position.y)
                        greyCircle.position = adjustedPosition
                        resetButton.addChild(greyCircle)
                    } else {
                        let greyRing = SKSpriteNode(imageNamed: "greyRing")
                        greyRing.size = CGSize(width: boardSize/8, height: boardSize/8)
                        greyRing.alpha = 0.5 // alpha = 0.5 --> 50% transparent
                        let intendedPosition = calculateSquareLocFromName(name: curItem)
                        let adjustedPosition = CGPoint(x: intendedPosition.x - resetButton.position.x, y: intendedPosition.y - resetButton.position.y)
                        greyRing.position = adjustedPosition
                        resetButton.addChild(greyRing)
                    }
                }
            }
        }
    }
    
    // converts locationArray to "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" to locationArray
    func convertLocationArrayToFen(locationArray: [[String]]) -> String {
        var fenString = ""
        var rowNum = 0
        for row in locationArray {
            var emptySpaces = 0
            var col = 0
            for loc in row {
                if loc == "" {
                    emptySpaces += 1
                    if col == 7 {
                        fenString += String(emptySpaces)
                    }
                } else {
                    if emptySpaces != 0 {
                        fenString += String(emptySpaces)
                        emptySpaces = 0
                    }
                    let color = String(loc[0])
                    var name = String(loc[1])
                    if color == "w" {
                        name = name.uppercased()
                    }
                    fenString += name
                }
                col += 1
            }
            if rowNum != 7 {
                fenString += "/"
            }
            rowNum += 1
        }
        var nextMover = " w "
        if (moveNumber % 2 == 0) {
            nextMover = " b "
        }
        let infoString = "KQkq - 0 1" // should be fine as a constant
        let totalFen = fenString + nextMover + infoString
        
        return totalFen
    }
    
    
    func pressContinueButton() {
        if tapNumber < fenLines.count-1 {
            unselectPiece()
            tapNumber += 1
            curLocationArray = convertFenToLocationArray(fenLine: fenLines[tapNumber])
            drawPieces(locationArray: curLocationArray)
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        }
    }
    
    func pressBackButton() {
        unselectPiece()
        if tapNumber >= 1 {
            tapNumber -= 1
            curLocationArray = convertFenToLocationArray(fenLine: fenLines[tapNumber])
            drawPieces(locationArray: curLocationArray)
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        } else if tapNumber == 0 {
            tapNumber -= 1
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        }
    }
    
    func removeThingsGood() {
        self.removeChildren(in: [correct,incorrect])
        pressContinueButton()
    }
    
    func removeThingsBad() {
        self.removeChildren(in: [correct,incorrect])
        pressBackButton()
    }
    

    func pressNextMoveListButton() {
        unselectPiece()
        if listNumber+1 < fenLinesList.count {
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            tapNumber = -1
            listNumber += 1
            titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(filenames.count) + ")"
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        }
    }
    
    func pressBackMoveListButton() {
        unselectPiece()
        if listNumber > 0 {
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            tapNumber = -1
            listNumber -= 1
            titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(filenames.count) + ")"
            moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        }
    }
    
    func pressResetButton() {
        resetButton.removeAllChildren()
        curLocationArray = originalSetup
        drawPieces(locationArray: curLocationArray)
        tapNumber = -1
        unselectPiece()
        moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
    }
    
    func pressMenuButton() {
        let nextScene = GameScene(fileNamed: "MenuScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.removeChildren(in: [correct,incorrect,doneLabel])
            fenLines = fenLinesList[listNumber]
            nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
            if nodeTouched == continueButton {
                pressContinueButton()
            } else if nodeTouched == backButton {
                pressBackButton()
            } else if nodeTouched == nextMoveListButton {
                pressNextMoveListButton()
            } else if nodeTouched == backMoveListButton {
                pressBackMoveListButton()
            } else if nodeTouched == resetButton {
                pressResetButton()
            } else if nodeTouched == menuButton {
                pressMenuButton()
            } else {
                let touchLocation = calculateSquareLocation(point: touch.location(in: self), locationArray: curLocationArray) // ex: ["a1","wr"]
                let name = touchLocation[1]
                if name != "invalid" {
                    if !pieceSelected && name != "" {
                        if (tapNumber % 2 == 0 && String(name[0]) == "b") || (tapNumber % 2 != 0 && String(name[0]) == "w") || (tapNumber >= fenLines.count-1) {
                            selectedPiece = touchLocation
                            pieceSelected = true
                            greenBorder.position = calculateSquareLocFromName(name: selectedPiece[0])
                            self.addChild(greenBorder)
                            showPossibleMoves()
                        }
                    } else if pieceSelected {
                        let piece1 = selectedPiece[1]
                        let color1 = String(piece1[0])
                        var color2 = ""
                        if name != "" {
                            color2 = String(name[0])
                        }
                        let isSameColor = color1 == color2
                        
                        if selectedPiece[0] == touchLocation[0] {
                            unselectPiece()
                        } else if isSameColor {
                            unselectPiece()
                            selectedPiece = touchLocation
                            pieceSelected = true
                            greenBorder.position = calculateSquareLocFromName(name: selectedPiece[0])
                            self.addChild(greenBorder)
                            showPossibleMoves()
                        } else {
                            let moveAllowed = isMoveAllowed(pieceName: selectedPiece[1], startLocation: selectedPiece[0], endLocation: touchLocation[0], locationArray: curLocationArray, moving: true)
                            if moveAllowed {
                                let originalLocation = selectedPiece[0] // ex: "a1"
                                let pieceName = selectedPiece[1] // ex: "wr"
                                let destination = touchLocation[0]
                                let origRowColVal = convertStringLocationToIndex(stringLocation: originalLocation)
                                let newRowColVal = convertStringLocationToIndex(stringLocation: destination)
                                curLocationArray[origRowColVal[0]][origRowColVal[1]] = ""
                                curLocationArray[newRowColVal[0]][newRowColVal[1]] = pieceName
                                pieceSelected = false
                                board.removeAllChildren()
                                drawPieces(locationArray: curLocationArray)
                                self.removeChildren(in: [greenBorder])
                                unselectPiece()
                                
                                if tapNumber+1 < fenLines.count {
                                    if curLocationArray == convertFenToLocationArray(fenLine: fenLines[tapNumber+1]) {
                                        self.addChild(correct)
                                        tapNumber += 1
                                        moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) { [self] in
                                            removeThingsGood()
                                        }
                                    } else {
                                        self.addChild(incorrect)
                                        tapNumber += 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) { [self] in
                                            removeThingsBad()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if curLocationArray == convertFenToLocationArray(fenLine: fenLines.last!) {
            self.addChild(doneLabel)
        }
    }
}
    












                       /*
                       } else if pieceSelected {
                           let originalLocation = selectedPiece[0] // ex: "a1"
                           let pieceName = selectedPiece[1] // ex: "wr"
                           let destination = touchLocation[0] // ex: "a1"
                           if isMoveAllowed(pieceName: pieceName, startLocation: originalLocation, endLocation: touchLocation[0], locationArray: curLocationArray) {
                               let origRowColVal = convertStringLocationToIndex(stringLocation: originalLocation)
                               let newRowColVal = convertStringLocationToIndex(stringLocation: destination)
                               curLocationArray[origRowColVal[0]][origRowColVal[1]] = ""
                               curLocationArray[newRowColVal[0]][newRowColVal[1]] = pieceName
                               pieceSelected = false
                               board.removeAllChildren()
                               drawPieces(locationArray: curLocationArray)
                               self.removeChildren(in: [greenBorder])
                           }
                       }
                   }
               }
           }
       }
}







/*
 func pressContinueButton() {
     if tapNumber < fenLines.count-1 {
         unselectPiece()
         tapNumber += 1
         curLocationArray = convertFenToLocationArray(fenLine: fenLines[tapNumber])
         drawPieces(locationArray: curLocationArray)
         moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
     }
 }
 
 func pressBackButton() {
     unselectPiece()
     if tapNumber >= 1 {
         tapNumber -= 1
         curLocationArray = convertFenToLocationArray(fenLine: fenLines[tapNumber])
         drawPieces(locationArray: curLocationArray)
         moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
     } else if tapNumber == 0 {
         tapNumber -= 1
         curLocationArray = originalSetup
         drawPieces(locationArray: curLocationArray)
         moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
     }
 }
 
 func removeThingsGood() {
     self.removeChildren(in: [correct,incorrect])
     pressContinueButton()
 }
 
 func removeThingsBad() {
     self.removeChildren(in: [correct,incorrect])
     pressBackButton()
 }
 

 func pressNextMoveListButton() {
     unselectPiece()
     if listNumber+1 < fenLinesList.count {
         curLocationArray = originalSetup
         drawPieces(locationArray: curLocationArray)
         tapNumber = -1
         listNumber += 1
         titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(filenames.count) + ")"
         moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
     }
 }
 
 func pressBackMoveListButton() {
     unselectPiece()
     if listNumber > 0 {
         curLocationArray = originalSetup
         drawPieces(locationArray: curLocationArray)
         tapNumber = -1
         listNumber -= 1
         titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(filenames.count) + ")"
         moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
     }
 }
 
 func pressResetButton() {
     curLocationArray = originalSetup
     drawPieces(locationArray: curLocationArray)
     tapNumber = -1
     unselectPiece()
     moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
 }
 
 func pressMenuButton() {
     let nextScene = GameScene(fileNamed: "MenuScene")!
     nextScene.scaleMode = .aspectFill
     scene?.view?.presentScene(nextScene)
 }
 
 func useApi(fen: String, numVariations: Int, completion: @escaping (CloudEval)->()) {
     // API WORK //
     let site = "https://lichess.org/api/cloud-eval?fen=" + fen + "&multiPv=" + String(numVariations)
     let urlString = site.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
     let url = URL(string: urlString!)
     group1.enter()
     
     guard url != nil else {
         print("url object is nil")
         completion(CloudEval())
         return
     }
     
     let session = URLSession.shared
     let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
         //check for errors
         if error == nil && data != nil{
             // parse json
             let decoder = JSONDecoder()
             
             do {
                 let cloudEval = try decoder.decode(CloudEval.self, from: data!)
                 completion(cloudEval)
             } catch {
                 print("hey")
             }
         }
     })
     dataTask.resume()
 }
 
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
     useApi(fen: "rnbqkbnr/ppp1pppp/8/3pP3/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 2", numVariations: 3) {cloudEval in
         DispatchQueue.main.async {
             self.apiResult = cloudEval
             self.group1.leave()
         }
     }
     
     group1.notify(queue: .main) {
         print(self.apiResult.fen.description)
     }
     
     //print("Fen: " + cloudEval)
     //print(cloudEval.description)
     //print("Variations: ")
     //print(cloudEval.pvs.description)
     print("---------------")
     for touch in touches {
         self.removeChildren(in: [correct,incorrect,doneLabel])
         resetButton.removeAllChildren()
         fenLines = fenLinesList[listNumber]
         nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
         if nodeTouched == continueButton {
             pressContinueButton()
         } else if nodeTouched == backButton {
             pressBackButton()
         } else if nodeTouched == nextMoveListButton {
             pressNextMoveListButton()
         } else if nodeTouched == backMoveListButton {
             pressBackMoveListButton()
         } else if nodeTouched == resetButton {
             pressResetButton()
         } else if nodeTouched == menuButton {
             pressMenuButton()
         } else {
             let touchLocation = calculateSquareLocation(point: touch.location(in: self), locationArray: curLocationArray) // ex: ["a1","wr"]
             let name = touchLocation[1]
             if name != "invalid" {
                 if !pieceSelected && name != "" {
                     if (tapNumber % 2 == 0 && String(name[0]) == "b") || (tapNumber % 2 != 0 && String(name[0]) == "w") || (tapNumber >= fenLines.count-1) {
                         selectedPiece = touchLocation
                         pieceSelected = true
                         greenBorder.position = calculateSquareLocFromName(name: selectedPiece[0])
                         self.addChild(greenBorder)
                         showPossibleMoves()
                     }
                 } else if pieceSelected {
                     if selectedPiece[0] == touchLocation[0] {
                         unselectPiece()
                     } else {
                         let moveAllowed = isMoveAllowed(pieceName: selectedPiece[1], startLocation: selectedPiece[0], endLocation: touchLocation[0], locationArray: curLocationArray, moving: true)
                         if moveAllowed {
                             let originalLocation = selectedPiece[0] // ex: "a1"
                             let pieceName = selectedPiece[1] // ex: "wr"
                             let destination = touchLocation[0]
                             let origRowColVal = convertStringLocationToIndex(stringLocation: originalLocation)
                             let newRowColVal = convertStringLocationToIndex(stringLocation: destination)
                             curLocationArray[origRowColVal[0]][origRowColVal[1]] = ""
                             curLocationArray[newRowColVal[0]][newRowColVal[1]] = pieceName
                             pieceSelected = false
                             board.removeAllChildren()
                             drawPieces(locationArray: curLocationArray)
                             self.removeChildren(in: [greenBorder])
                             unselectPiece()
                             
                             if tapNumber+1 < fenLines.count {
                                 if curLocationArray == convertFenToLocationArray(fenLine: fenLines[tapNumber+1]) {
                                     self.addChild(correct)
                                     tapNumber += 1
                                     moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                         removeThingsGood()
                                     }
                                 } else {
                                     self.addChild(incorrect)
                                     tapNumber += 1
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                         removeThingsBad()
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
     }
     if tapNumber+1 == fenLines.count {
         self.addChild(doneLabel)
     }
 }
 
 
 */












                    /*
                    } else if pieceSelected {
                        let originalLocation = selectedPiece[0] // ex: "a1"
                        let pieceName = selectedPiece[1] // ex: "wr"
                        let destination = touchLocation[0] // ex: "a1"
                        if isMoveAllowed(pieceName: pieceName, startLocation: originalLocation, endLocation: touchLocation[0], locationArray: curLocationArray) {
                            let origRowColVal = convertStringLocationToIndex(stringLocation: originalLocation)
                            let newRowColVal = convertStringLocationToIndex(stringLocation: destination)
                            curLocationArray[origRowColVal[0]][origRowColVal[1]] = ""
                            curLocationArray[newRowColVal[0]][newRowColVal[1]] = pieceName
                            pieceSelected = false
                            board.removeAllChildren()
                            drawPieces(locationArray: curLocationArray)
                            self.removeChildren(in: [greenBorder])
                        }
                    }
                }
            }
        }
    }
}
    
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    // function called when reset button is touched
    /*
    func callbackButton() {
        board.removeAllChildren()
        locationArray = originalSetup
        tapNumber = 0
        pieceSelected = false
        self.removeChildren(in: [greenBorder])
        drawPieces()
        numWhiteMoves = 0
        numBlackMoves = 0
    }*/
    /*
    // function called when continue button is touched
    func callContinueButton() {
        let numMoveList = convertToNumMoveList(strMoveList: strMoveList)
        if tapNumber < numMoveList.count - 1 {
            board.removeAllChildren()
            let curMove = numMoveList[tapNumber]
            let pieceToBeMoved = locationArray[curMove[0]][curMove[1]]
            locationArray[curMove[0]][curMove[1]] = ""
            locationArray[curMove[2]][curMove[3]] = pieceToBeMoved
            pieceSelected = false
            self.removeChildren(in: [greenBorder])
            drawPieces()
            tapNumber = tapNumber + 1
            
            if pieceToBeMoved != "" {
                if String(pieceToBeMoved[0]) == "w" {
                    numWhiteMoves += 1
                } else {
                    numBlackMoves += 1
                }
            }
        }
    }*/
    
    /*
    // function called to show potential moves of selected piece
    func showPotentialMoves(pieceName: String,startLocation: String) {
        let boardSize = boardMult2*frame.width

        //let endSquare = convertStringLocationToIndex(stringLocation: endLocation) // ex: [7,0]
        //let capturedPiece = locationArray[endSquare[0]][endSquare[1]] // ex: "wr"
        
        for stringList in stringArray {
            for stringLocation in stringList {
                if isMoveAllowed(pieceName: pieceName, startLocation: startLocation, endLocation: stringLocation) {
                    if startLocation != stringLocation {
                        let greyCircle = SKSpriteNode(imageNamed: "lightGreyCircle")
                        greyCircle.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
                        let cgPoint = calculateSquareLocFromName(name: stringLocation)
                        greyCircle.position = cgPoint
                        self.addChild(greyCircle)
                    }
                }
            }
        }
    }*/
    
    // shows whether a move followed the next move in the strMoveList
    /*
    func showCorrectOrNot(moveSet: [String]) {
        if tapNumber < strMoveList.count {
            let boardSize = boardMult2*frame.width
            if moveSet == strMoveList[tapNumber] {
                let correct = SKSpriteNode(imageNamed: "correct")
                correct.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
                correct.position = CGPoint(x: 0, y: 11*boardSize/16)
                board.addChild(correct)
                tapNumber += 1
            } else {
                let incorrect = SKSpriteNode(imageNamed: "incorrect")
                incorrect.scale(to: CGSize(width: boardSize/7, height: boardSize/7))
                incorrect.position = CGPoint(x: 0, y: 11*boardSize/16)
                board.addChild(incorrect)
            }
        }
    }*/
    
    /*
    func callNextMoveList() {
        callbackButton()
        moveNumber += 1
    }
    
    func callBackMoveList() {
        callbackButton()
        moveNumber -= 1
    }*/

    /*
    // Functional; plays out moves stored in strMoveList
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //readPgnFile()
        let a = convertPgnMovesToStrMoveList(whiteMoves: whiteMoveList, blackMoves: blackMoveList)
        print(a.description)
        if moveNumber < totalStrMoveList.count && moveNumber > -1 {
            strMoveList = totalStrMoveList[moveNumber]
        }
        
        for touch in touches {
            let touchLocation = calculateSquareLocation(point: touch.location(in: self)) // ex: ["a1","wr"]
            nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
            
            if nodeTouched == backButton {
                callbackButton()
            } else if nodeTouched == continueButton {
                callContinueButton()
            } else if nodeTouched == nextMoveListButton {
                callNextMoveList()
            } else if nodeTouched == backMoveListButton {
                callBackMoveList()
            } else if touchLocation[1] != "invalid" {
                if !pieceSelected && touchLocation[1] != "" {
                    
                    selectedPiece = touchLocation
                    pieceSelected = true
                    greenBorder.position = calculateSquareLocFromName(name: selectedPiece[0])
                    self.addChild(greenBorder)
                    //showPotentialMoves(pieceName: selectedPiece[1], startLocation: selectedPiece[0])
                } else if pieceSelected {
                    
                    let originalLocation = selectedPiece[0] // ex: "a1"
                    let pieceName = selectedPiece[1] // ex: "wr"
                    let destination = touchLocation[0] // ex: "a1"
                    //print(isMoveAllowed(pieceName: pieceName, startLocation: originalLocation, endLocation: touchLocation[0]).description)
                    
                    if isMoveAllowed(pieceName: pieceName, startLocation: originalLocation, endLocation: touchLocation[0]) {

                        let origRowColVal = convertStringLocationToIndex(stringLocation: originalLocation)
                        let newRowColVal = convertStringLocationToIndex(stringLocation: destination)
                        
                        locationArray[origRowColVal[0]][origRowColVal[1]] = ""
                        locationArray[newRowColVal[0]][newRowColVal[1]] = pieceName
                        pieceSelected = false
                        board.removeAllChildren()
                        drawPieces()
                        self.removeChildren(in: [greenBorder])
                        if String(pieceName[0]) == "b" {
                            numBlackMoves += 1
                        } else if String(pieceName[0]) == "w" {
                            numWhiteMoves += 1
                        }
                        
                        if originalLocation != destination {
                            showCorrectOrNot(moveSet: [originalLocation,destination])
                        }
                    }
                }
            }
        }
    }*/
    
    /*
    func readPgnFile() {
        
        //place the file Textfile.txt in the executable directory
        let file = "sample"
        if let path = Bundle.main.path(forResource: file, ofType: "pgn"){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                let text = myStrings.joined(separator: " ")
                result = text.description
            } catch {
                result = "error"
            }
        }
        
        // result has values now
        let index = result.index(after: result.lastIndex(of: "]")!)
        let mySubstring = result[index...]
        var trimmedString = mySubstring.components(separatedBy: .newlines).joined()
        let removeCharacters: Set<Character> = ["!", "#","+","?"]
        trimmedString.removeAll(where: { removeCharacters.contains($0) } )
        let spaceIndex = trimmedString.index(before: trimmedString.lastIndex(of: " ")!)
        trimmedString = String(trimmedString[...spaceIndex])
        
        
        let lastPeriodIndex = trimmedString.lastIndex(of: ".")
        let tempString = String(trimmedString[...lastPeriodIndex!])
        let lastSpaceIndex = tempString.lastIndex(of: " ")
        var totalMoveNumString = String(tempString[lastSpaceIndex!...lastPeriodIndex!])
        totalMoveNumString.removeFirst()
        totalMoveNumString.removeLast()
        let totalMoveNum = Int(totalMoveNumString)
        var curMove = String()
        for moveNum in 1...totalMoveNum! {
            let numIndex = trimmedString.index(after: trimmedString.firstIndex(of: ".")!)
            trimmedString.removeSubrange(...numIndex)
            var newIndex = trimmedString.index(trimmedString.endIndex, offsetBy: -1)
            if moveNum < 9 {
                newIndex = trimmedString.index(trimmedString.firstIndex(of: ".")!, offsetBy: -3)
            } else if moveNum < totalMoveNum! {
                newIndex = trimmedString.index(trimmedString.firstIndex(of: ".")!, offsetBy: -4)
            }
            curMove = String(trimmedString[...newIndex])
            moveList.append(curMove)
        }
        
        for thisMove in moveList {
            if !thisMove.contains(" ") {
                whiteMoveList.append(thisMove)
            } else {
                let indexVal = thisMove.firstIndex(of: " ")!
                var whiteMove = String(thisMove[...indexVal])
                var blackMove = String(thisMove[indexVal...])
                whiteMove = whiteMove.filter {!$0.isWhitespace}
                blackMove = blackMove.filter {!$0.isWhitespace}
                whiteMoveList.append(whiteMove)
                blackMoveList.append(blackMove)
            }
        }
    }*/
/*
    // output: [["d2","d4"],["d7","d5"],["c1","f4"],["b8","c6"],["e2","e4"]]
    func convertPgnMovesToStrMoveList(whiteMoves: [String], blackMoves: [String]) -> [[[String]]] {
        var output = [[String]]()
        
        // finding second locations
        var last2WList = [String]()
        var last2BList = [String]()
        for wm in whiteMoves {
            if wm.contains("=") {
                let equalsIndex = wm.index(before: wm.firstIndex(of: "=")!)
                let secondIndex = wm.index(equalsIndex, offsetBy: -1)
                let val = String(wm[secondIndex...equalsIndex])
                last2WList.append(val)
            } else if wm.contains("-") {
                if wm.count == 5 {
                    last2WList.append("wqsc!") // white queen side castle
                } else {
                    last2WList.append("wksc!") // white king side castle
                }
            } else {
                last2WList.append(String(wm.suffix(2)))
            }
        }
        for bm in blackMoves {
            if bm.contains("=") {
                let equalsIndex = bm.index(before: bm.firstIndex(of: "=")!)
                let secondIndex = bm.index(equalsIndex, offsetBy: -1)
                let val = String(bm[secondIndex...equalsIndex])
                last2BList.append(val)
            } else if bm.contains("-") {
                if bm.count == 5 {
                    last2BList.append("bqsc!") // black queen side castle
                } else {
                    last2BList.append("bksc!") // black king side castle
                }
            } else {
                last2BList.append(String(bm.suffix(2)))
            }
        }
        
        // filling in second locations
        var lastListIndex = 0
        for _ in 0...last2WList.count-1 {
            output.append(["",last2WList[lastListIndex]])
            if lastListIndex < last2BList.count {
                output.append(["",last2BList[lastListIndex]])
            }
            lastListIndex += 1
        }
        //output.insert(["hi"], at: 0)
        
        // finding first locations
        // trying to find output[outputIndex][0]
        var totalMovers = [[[String]]]()
        
        
        for outputIndex in 0...last2WList.count-1 {
            var potentialMovers = [[String]]()
            for stringList in stringArray {
                for stringLocation in stringList {
                    var color = ""
                    if outputIndex % 2 == 0 {
                        color = "w"
                    } else {
                        color = "b"
                    }
                    
                    let pieceNameIndex = convertStringLocationToIndex(stringLocation: stringLocation)
                    let pieceName = refLocationArray[pieceNameIndex[0]][pieceNameIndex[1]]
                    if pieceName != "" {
                        if String(pieceName[0]) == color {
                            if !output[outputIndex][1].contains("!") {
                                if isMoveAllowed(pieceName: pieceName, startLocation: stringLocation, endLocation: output[outputIndex][1]) {
                                    potentialMovers.append([pieceName,stringLocation])
                                }
                            } else {
                                // castling is occurring
                                
                            }
                        }
                    }
                }
            }
            totalMovers.append(potentialMovers)
        }
            
        
        return totalMovers
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
 
 
 
 
 
 
 
 
 
 let a = 1
 if a == 1 {
     print("a")
     Task {
         do {
             let c = try await test2()
             print(c.fen.description)
         } catch {
             
         }
     }
     print("b")
     
 } else {
 
 
 
 
 
 

 
 
 
 
 
 func useApi(fen: String, numVariations: Int, completion: @escaping (CloudEval)->()) {
     // API WORK //
     let site = "https://lichess.org/api/cloud-eval?fen=" + fen + "&multiPv=" + String(numVariations)
     let urlString = site.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
     let url = URL(string: urlString!)
     group1.enter()
     group2.enter()
     
     guard url != nil else {
         print("url object is nil")
         completion(CloudEval())
         return
     }
     
     let session = URLSession.shared
     let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
         //check for errors
         if error == nil && data != nil{
             // parse json
             let decoder = JSONDecoder()
             
             do {
                 let cloudEval = try decoder.decode(CloudEval.self, from: data!)
                 completion(cloudEval)
                 self.group1.leave()
             } catch {
                 completion(CloudEval())
                 print("hey")
             }
         }
     })
     dataTask.resume()
     group1.wait()
 }
 
 
 
 
 

 func test2() async throws -> CloudEval {
     let urlString = "https://lichess.org/api/cloud-eval?fen=rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1)"
     
     let urlFinal = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
     guard let url = URL(string: urlFinal!) else {
         throw "Error here"
     }
     
     let (data, _) = try await URLSession.shared.data(from: url)
     let cloudEval = try JSONDecoder().decode(CloudEval.self, from: data)
     
     return cloudEval
 }
 
 
 
 
 
 
 
 group1.notify(queue: .main) {
     if self.apiResult.fen != "" {

         print(moveString.description)
         
     
         if correctMove == actualMove {
             self.addChild(self.correct)
             let curFen = self.convertLocationArrayToFen(locationArray: self.curLocationArray)
             self.useApi(fen: curFen, numVariations: numLines) {cloudEval in
                 DispatchQueue.main.async {
                     self.apiResult = cloudEval
                     self.group2.leave()
                 }
             }
             self.group2.notify(queue: .main) {
                 let randIndex = Int.random(in: 1...self.apiResult.pvs.count)
                 let selectedVariation = self.apiResult.pvs[randIndex-1]
                 let selectedMoveString = selectedVariation.moves
                 let nextMove = selectedMoveString.prefix(4)
                 self.tapNumber += 1
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                     removeThingsGood()
                     let startSpot = convertStringLocationToIndex(stringLocation: String(nextMove.prefix(2)))
                     let endSpot = convertStringLocationToIndex(stringLocation: String(nextMove.suffix(2)))
                     curLocationArray[endSpot[0]][endSpot[1]] = curLocationArray[startSpot[0]][startSpot[1]]
                     curLocationArray[startSpot[0]][startSpot[1]] = ""
                     drawPieces(locationArray: curLocationArray)
                     moveNumber += 1
                 }
             }
         } else {
             self.addChild(self.incorrect)
             self.tapNumber += 1
             DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                 removeThingsBad()
                 curLocationArray = prevLocationArray
                 drawPieces(locationArray: curLocationArray)
                 moveNumber -= 1
             }
         }
     } else {
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
             self.addChild(moveNumberLabel)
         }
     }
 }
 */*/

