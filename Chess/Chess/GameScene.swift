//
//  GameScene.swift
//  Chess
//
//  Created by William Becht on 3/2/22.
//

import SpriteKit
import GameplayKit
import SwiftUI
import Foundation

class GameScene: SKScene {
    
    /* Guide for Z-Positions (pieceId):
     ALL VALUES MINUS 1
     
     whitePawns: 1-8
     whiteRook1: 9
     whiteRook8: 10
     whiteKnight2: 11
     whiteKnight7: 12
     whiteBishop3: 13
     whiteBishop6: 14
     whiteQueen: 15
     whiteKing: 16
     
     blackPawns: 17-24
     blackRook1: 25
     blackRook8: 26
     blackKnight2: 27
     blackKnight7: 28
     blackBishop3: 29
     blackBishop6: 30
     blackQueen: 31
     blackKing: 32
    */
    
    // Change the size of the board here
    var boardMult = 0.75
    
    var board = SKSpriteNode(imageNamed: "board")
    var blackPawn = SKSpriteNode(imageNamed: "blackPawn")
    var blackNight = SKSpriteNode(imageNamed: "blackKnight")
    var continueButton = SKSpriteNode(imageNamed: "continueButton")
    var resetButton = SKSpriteNode(imageNamed: "resetButton")
    var nextMoveListButton = SKSpriteNode(imageNamed: "forwardButton")
    var backMoveListButton = SKSpriteNode(imageNamed: "backwardButton")
    var greenCircle = SKSpriteNode(imageNamed: "greenCircle")
    var redCircle = SKSpriteNode(imageNamed: "redCircle")
    var greenBorder = SKSpriteNode(imageNamed: "greenBorder")
    //var potentialSquare = SKSpriteNode(imageNamed: "potentialSquare")
    var firstTouch = CGPoint()
    var nextTouch = CGPoint()
    var needToTouch = true
    var selectedPiece = [String]()
    var pieceSelected = false
    var tapNumber = 0
    var numWhiteMoves = 0
    var numBlackMoves = 0
    
    var moveList = [String]()
    var whiteMoveList = [String]()
    var blackMoveList = [String]()
    
    var result = "nothing"
    
    
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
    /*
    var locationArray: [[String]] = [
        ["br1", "bn2", "bb3", "bq", "bk","bb6", "bn7", "br8"],
        ["bp1", "bp2", "bp3", "bp4", "bp5","bp6", "bp7", "bp8"],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["wp1", "wp2", "wp3", "wp4", "wp5","wp6", "wp7", "wp8"],
        ["wr1", "wn2", "wb3", "wq", "wk","wb6", "wn7", "wr8"],
      ]
*/
    var locationArray: [[String]] = [
        ["br", "bn", "bb", "bq", "bk","bb", "bn", "br"],
        ["bp", "bp", "bp", "bp", "bp","bp", "bp", "bp"],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["wp", "wp", "wp", "wp", "wp","wp", "wp", "wp"],
        ["wr", "wn", "wb", "wq", "wk","wb", "wn", "wr"],
      ]
    
    var refLocationArray: [[String]] = [
        ["br", "bn", "bb", "bq", "bk","bb", "bn", "br"],
        ["bp", "bp", "bp", "bp", "bp","bp", "bp", "bp"],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["", "", "", "", "","", "", ""],
        ["wp", "wp", "wp", "wp", "wp","wp", "wp", "wp"],
        ["wr", "wn", "wb", "wq", "wk","wb", "wn", "wr"],
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
    
    var idArray = ["wp1","wp2","wp3","wp4","wp5","wp6","wp7","wp8","wr1","wr8","wk2","wk7","wb3","wb6",
                   "wq","wk","bp1", "bp2","bp3","bp4","bp5","bp6","bp7","bp8","br1","br8","bk2","bk7",
                   "bb3","bb6","bq","bk"]
    
    var letterDict = ["a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7]
    
    var strMoveList = [["d2","d4"],["d7","d5"],["c1","f4"],["b8","c6"],["e2","e3"]]
    
    var passantEligibleList = [[0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0]]
    
    var castleEligibleList = [[1,1],
                              [1,1]]
    
    var totalStrMoveList = [[["d2","d4"],["d7","d5"],["c1","f4"],["b8","c6"],["e2","e3"]],
                            [["d2","d4"],["d7","d5"],["c1","f4"],["b8","c6"],["e2","e4"]]]
    
    var moveNumber = 0
    
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
        let boardSize = boardMult*frame.width
        let rowCol = convertStringLocationToIndex(stringLocation: name) // ex: [7,0]
        let inValx = boardSize*(-7/16)
        let inValy = boardSize*(7/16)
        let x = inValx+Double(rowCol[1])*(boardSize/8)
        let y = inValy-Double(rowCol[0])*(boardSize/8)
        return CGPoint(x: x, y: y)
    }

    // returns CGPoint as ["a1","wr1"]
    func calculateSquareLocation(point: CGPoint) -> [String] {
        let boardSize = boardMult*frame.width
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
    
    
    /*
    func isMoveAllowed(pieceZ: Int,startLocation: [String],endLocation: [String]) -> Bool {
        // white pawn rules
        if pieceZ < 8 {
            let initialRank = startLocation[0][1].wholeNumberValue!
            let finalRank = endLocation[0][1].wholeNumberValue!
            let diff = finalRank - initialRank
            if endLocation[1] == "" && diff > 0 && diff < 2  {
                return true
            }
        }
        
        return true
    }
     */
    
    func isMoveAllowed(pieceName: String,startLocation: String,endLocation: String) -> Bool {
        let color = String(pieceName[0]) // ex: "w" or "b"
        let pieceIdentifier = String(pieceName[1]) // ex: "r" for rook
        let startSquare = convertStringLocationToIndex(stringLocation: startLocation) // ex: [7,0]
        let endSquare = convertStringLocationToIndex(stringLocation: endLocation) // ex: [7,0]
        let capturedPiece = locationArray[endSquare[0]][endSquare[1]] // ex: "wr"
        var capColor = ""
        
        if capturedPiece == pieceName && endSquare == startSquare {
            return true
        }
        
        /*
        if color == "w" && numBlackMoves < numWhiteMoves {
            return false
        }
        
        if color == "b" && numBlackMoves == numWhiteMoves {
            return false
        }*/
        
        if !capturedPiece.isEmpty {
            capColor = String(capturedPiece[0])
        }
        
        let jumpVerticalDistance = endSquare[0] - startSquare[0]
        let jumpHorzDistance = endSquare[1] - startSquare[1]
        
        // cannot move nothing
        if pieceName == "" {
            return false
        }
        

        
        // cannot capture piece of same color
        if capturedPiece != "" {
            // allowed to capture yourself (exact same piece)
            if pieceName != capturedPiece && startSquare != endSquare {
                if capColor == color {
                    return false
                }
            }
        }
        
        // Need:
        // pawn: en passant, queening
        // king: castling
        // queen: stop jumping over pieces
        // bishop: stop jumping over pieces
        // rook: stop jumping over pieces
        // knight: should be done
        

        switch pieceIdentifier {
        case "p":
            //print("pawn")
            // en passant rules
            // NEEDS WORK
            
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
            // can only move one space (diagonally or laterally)
            if abs(jumpVerticalDistance) > 1 || abs(jumpHorzDistance) > 2 {
                return false
            }
            if abs(jumpVerticalDistance) > 1 && abs(jumpHorzDistance) > 1 {
                return false
            }
            
            /*
            // castling rules
            if color == "w" && startSquare == [7,4] {
                // white castling king side
                if endSquare == [7,6] && castleEligibleList[1][1] == 1 {
                    return true
                }
                if endSquare == [7,2] && castleEligibleList[1][0] == 1 {
                    return true
                }
            }
            if color == "b" && startSquare == [0,4] {
                // black castling king side
                if endSquare == [0,6] && castleEligibleList[0][1] == 1 {
                    return true
                }
                if endSquare == [0,2] && castleEligibleList[0][0] == 1 {
                    return true
                }
            }
            if abs(jumpHorzDistance) > 1 {
                return false
            }
             */
            
            
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
    func drawPieces() {
        let boardSize = boardMult*frame.width
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
    
    
    
    // called everytime the app moves to this view (startup view as of rn)
    override func didMove(to view: SKView) {
        // Creating board size and position; adding to screen
        let boardSize = boardMult*frame.width
        let boardX = 0
        let boardY = 0
        board.position = CGPoint(x: boardX, y: boardY)
        board.size = CGSize(width: boardSize, height: boardSize)
        self.addChild(board)
        
        // adjusting button size and adding to screen
        continueButton.size = CGSize(width: continueButton.size.width * 0.6, height: continueButton.size.height*0.6)
        continueButton.position = CGPoint(x: boardSize/4, y: -boardSize/1.3)
        self.addChild(continueButton)
        
        resetButton.size = CGSize(width: resetButton.size.width * 0.5, height: resetButton.size.height*0.5)
        resetButton.position = CGPoint(x: -boardSize/4, y: -boardSize/1.3)
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
        
        
        drawPieces()
        
        // Create white pawn size; add to screen
        /*
        var mult = 1
        var idx = 0 // z-value
        while mult <= 15 {
            let whitePawn = SKSpriteNode(imageNamed: "wp")
            let whitePawnY = -(boardSize/2)+(boardSize/5.3)
            let whitePawnX = -(boardSize/2) + Double(mult)*(boardSize/16)
            whitePawn.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
            whitePawn.position = CGPoint(x: Double(whitePawnX), y: Double(whitePawnY))
            whitePawn.zPosition = CGFloat(idx)
            addChild(whitePawn)
            mult = mult + 2
            idx = idx + 1
        }
        
        // Create black pawn size; add to screen
        var multi = 1
        var ind = 16 // z-value
        while multi <= 15 {
            let blackPawn = SKSpriteNode(imageNamed: "bp")
            let blackPawnY = (boardSize/2)-(boardSize/5.3)
            let blackPawnX = -(boardSize/2) + Double(multi)*(boardSize/16)
            blackPawn.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
            blackPawn.position = CGPoint(x: Double(blackPawnX), y: Double(blackPawnY))
            blackPawn.zPosition = CGFloat(idx)
            addChild(blackPawn)
            ind = ind + 1
            multi = multi + 2
        }
         */

        
    }
    
    // create an array to define each square on the board
    // define location ranges for each square in that array
/*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if needToTouch {
                firstTouch = touch.location(in: self)
                needToTouch = false
                nodeTouched = nodes(at: firstTouch).first ?? SKNode()
                if nodeTouched == SKNode() || nodeTouched == board {
                    needToTouch = true
                }

            } else {
                nextTouch = touch.location(in: self)
                let pieceZ = nodeTouched.zPosition
                let startLocation = calculateSquareLocation(point: firstTouch)
                let endLocation = calculateSquareLocation(point: nextTouch)
                if isMoveAllowed(pieceZ: Int(pieceZ),startLocation: startLocation,endLocation: endLocation)  {
                    nodeTouched.run(SKAction.moveTo(y: nextTouch.y, duration: 0.2))
                    needToTouch = true
                }
            }
            print(calculateSquareLocation(point: touch.location(in: self)).description)
        }
        
    }
    
    */
    /*
    func highlightPiece(piece: [String]) {
        let boardSize = boardMult*frame.width
        let yellow = SKSpriteNode(imageNamed: "yellowSquare")
        yellow.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
        var y = boardSize*(7/16)
        var x = boardSize*(-7/16)
        let loc = piece[0]
        let col = loc[1]
        x = x + (boardSize*Double(col.wholeNumberValue!)/8)
        var ci = 0
        let char = Character(loc[0])
        for i in char ?? "" where ("a"..."z") ~= i {
            ci = Int(i.asciiValue!) - 96
        }
        y = y - ((boardSize*Double(ci))/8)
        yellow.position = CGPoint(x: x, y: y)
        addChild(yellow)
    }
     */
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let squareInfo = calculateSquareLocation(point: location)
            let boardLocation = squareInfo[0] // ex: "a5" or "invalid"
            let pieceInfo = squareInfo[1] //ex: "wr1" or "" or "invalid"
            
            // checking if the touch was on the board and was on a piece
            if boardLocation != "invalid" {
                if !pieceSelected && pieceInfo != "" {
                    print("here1")
                    print(calculateSquareLocation(point: touch.location(in: self)).description)
                    selectedPiece = [boardLocation, pieceInfo]
                    pieceSelected = true
                    //highlightPiece(piece: selectedPiece)
                } else if pieceSelected {
                    print("here2")
                    print(calculateSquareLocation(point: touch.location(in: self)).description)
                    var letter = boardLocation[0]
                    var col = letterDict[String(letter)]!
                    var row = boardLocation[1].wholeNumberValue!
                    locationArray[row][col] = selectedPiece[1]
                    
                    let boardLocation2 = selectedPiece[0]
                    letter = boardLocation2[0]
                    col = letterDict[String(letter)]!
                    row = boardLocation2[1].wholeNumberValue!
                    locationArray[row][col] = ""
                    pieceSelected = false
                    drawPieces()
                    print(selectedPiece[1])
                    print("now")
                } else {
                    print("nope2")
                }
            } else {
                print("Nope1")
            }
        }
    }
     */

    // function called when reset button is touched
    func callResetButton() {
        board.removeAllChildren()
        locationArray = originalSetup
        tapNumber = 0
        pieceSelected = false
        self.removeChildren(in: [greenBorder])
        drawPieces()
        numWhiteMoves = 0
        numBlackMoves = 0
    }
    
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
    }
    
    /*
    // function called to show potential moves of selected piece
    func showPotentialMoves(pieceName: String,startLocation: String) {
        let boardSize = boardMult*frame.width

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
    func showCorrectOrNot(moveSet: [String]) {
        if tapNumber < strMoveList.count {
            let boardSize = boardMult*frame.width
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
    }
    
    
    func callNextMoveList() {
        callResetButton()
        moveNumber += 1
    }
    
    func callBackMoveList() {
        callResetButton()
        moveNumber -= 1
    }

    
    // Functional; plays out moves stored in strMoveList
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        readPgnFile()
        let a = convertPgnMovesToStrMoveList(whiteMoves: whiteMoveList, blackMoves: blackMoveList)
        print(a.description)
        if moveNumber < totalStrMoveList.count && moveNumber > -1 {
            strMoveList = totalStrMoveList[moveNumber]
        }
        
        for touch in touches {
            let touchLocation = calculateSquareLocation(point: touch.location(in: self)) // ex: ["a1","wr"]
            nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
            
            if nodeTouched == resetButton {
                callResetButton()
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
    }
    
    
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
    }

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
