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

class GameSceneBot: SKScene {
    
    let labelVal = curTitle
    var doneLabel = SKLabelNode(fontNamed: chosenFont)
    var scoreLabel = SKLabelNode(fontNamed: chosenFont)
    var titleLabel = SKLabelNode(fontNamed: chosenFont)
    var board = SKSpriteNode(imageNamed: "board_green")
    var continueButton = SKSpriteNode(imageNamed: "continueButton")
    var resetButton = SKSpriteNode(imageNamed: "resetButton")
    var backButton = SKSpriteNode(imageNamed: "backButton")
    var nextMoveListButton = SKSpriteNode(imageNamed: "forwardButton")
    var pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var resumeButton = SKSpriteNode(imageNamed: "resumeButton")
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
    var listNumber = 0
    var fenLines = [String]()
    var fenLinesList = [[String]]()
    var moveList = [String]()
    var whiteMoveList = [String]()
    var blackMoveList = [String]()
    var prevLocationArray = [[String]]()
    var result = "nothing"
    var moveNumber = 0
    var setup = false
    var menuButtonNew = UIButton()
    let settingsButton = UIButton()
    
    
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
        let boardSize = boardMult*frame.width
        let rowCol = convertStringLocationToIndex(stringLocation: name) // ex: [7,0]
        let inValx = boardSize*(-7/16)
        let inValy = boardSize*(7/16)
        let x = inValx+Double(rowCol[1])*(boardSize/8)
        let y = inValy-Double(rowCol[0])*(boardSize/8)
        return CGPoint(x: x, y: y)
    }

    // returns CGPoint as ["a1","wr1"]
    func calculateSquareLocation(point: CGPoint,locationArray: [[String]]) -> [String] {
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
        
        // Creating board size and position; adding to screen
        let boardSize = boardMult*frame.width
        let boardX = 0
        let boardY = 0
        
        board.position = CGPoint(x: boardX, y: boardY)
        board.size = CGSize(width: boardSize, height: boardSize)
        self.addChild(board)
        
        resetButton.size = CGSize(width: resetButton.size.width * 0.45, height: resetButton.size.height * 0.45)
        resetButton.position = CGPoint(x: boardSize/4, y: -boardSize/1.3)
        self.addChild(resetButton)
        
        greenBorder.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
        
        resumeButton.size = CGSize(width: resumeButton.size.width * 0.265, height: resumeButton.size.height * 0.265)
        resumeButton.position = CGPoint(x: -boardSize/4, y: -boardSize/1.3)
        
        pauseButton.size = CGSize(width: pauseButton.size.width * 0.265, height: pauseButton.size.height * 0.265)
        pauseButton.position = CGPoint(x: -boardSize/4, y: -boardSize/1.3)
        self.addChild(pauseButton)
        
        scoreLabel.text = "Score: "
        scoreLabel.fontSize = 20
        scoreLabel.position = CGPoint(x: -boardSize/2.7, y: -boardSize/1.8)
        self.addChild(scoreLabel)
        
        titleLabel.position = CGPoint(x: 0, y: boardSize/1.17)
        titleLabel.text = labelVal
        titleLabel.fontSize = 40
        self.addChild(titleLabel)
        
        doneLabel.fontSize = 30
        doneLabel.text = "Position Not Found"
        doneLabel.position = CGPoint(x: 0, y: -boardSize/1.6)
        
        menuButton.size = CGSize(width: menuButton.size.width * 0.265, height: menuButton.size.height * 0.265)
        menuButton.position = CGPoint(x: -boardSize/2.4, y: boardSize/1.1)
        //self.addChild(menuButton)
        
        // CREATING MENU BUTTON
        let buttonSize = 40.0
        let largeConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc = UIImage(systemName: "arrowshape.turn.up.left.circle.fill", withConfiguration: largeConfig)
        menuButtonNew.setImage(largeBoldDoc, for: .normal)
        menuButtonNew.frame = CGRect(x: 10, y: 100, width: buttonSize, height: buttonSize)
        menuButtonNew.layer.cornerRadius = 0.5 * menuButtonNew.bounds.size.width
        menuButtonNew.clipsToBounds = true
        menuButtonNew.addTarget(self, action: #selector(menuButtonNewClicked(_ :)), for: .touchUpInside)
        self.view!.addSubview(menuButtonNew)
        
        // CREATING SETTINGS BUTTON
        let buttonSize2 = 50.0
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: buttonSize2, weight: .medium, scale: .default)
        let largeBoldDoc2 = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig2)
        settingsButton.setImage(largeBoldDoc2, for: .normal)
        settingsButton.frame = CGRect(x: 325, y: 100, width: buttonSize2, height: buttonSize2)
        settingsButton.layer.cornerRadius = 0.5 * settingsButton.bounds.size.width
        settingsButton.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked(_ :)), for: .touchUpInside)
        settingsButton.tintColor = .white
        self.view!.addSubview(settingsButton)
        
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
    }
    
    func showPossibleMoves() {
        //selectedPiece = ["a1","wr"]
        let boardSize = boardMult*frame.width
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
    
    func pressContinueButton() {
    }
    
    func pressBackButton() {
        unselectPiece()
    }
    
    func pressResetButton() {
        curLocationArray = originalSetup
        drawPieces(locationArray: curLocationArray)
        moveNumber = 0
        unselectPiece()
        self.removeChildren(in: [doneLabel,incorrect,correct])
        scoreLabel.text = "Score:"
    }
    
    func pressMenuButton() {
        let nextScene = GameScene(fileNamed: "MenuScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
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
    
    // use r2qkb1r/ppp1pppp/5n2/n7/2BP1Bb1/2N1P3/PP3PPP/R2QK1NR w KQkq - 1 7 to test error not found
    func useApi(fen: String, numVariations: Int) -> CloudEval {
        var cloudEval = CloudEval()
        let group = DispatchGroup()
        group.enter()
        
        let urlString = "https://lichess.org/api/cloud-eval?fen=" + fen + "&multiPv=" + String(numVariations)
        let urlFinal = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlFinal!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(CloudEval.self, from: data) {
                    cloudEval = result
                    group.leave()
                } else {
                    group.leave()
                }
            } else if let error = error {
                print(error)
                group.leave()
            }
        }
        task.resume()
        group.wait()
        
        return cloudEval
    }
    
    
    func removeButtons() {
        menuButtonNew.removeFromSuperview()
        settingsButton.removeFromSuperview()
    }
    
    
    @objc func menuButtonNewClicked(_: UIButton) {
        removeButtons()
        let nextScene = GameScene(fileNamed: "MenuScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    
    @objc func settingsButtonClicked(_: UIButton) {
        removeButtons()
        lastScene = "GameSceneBot"
        let nextScene = GameScene(fileNamed: "SettingsScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.removeChildren(in: [correct,incorrect,doneLabel])
            resetButton.removeAllChildren() // used to show possible moves
            nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
            if nodeTouched == continueButton {
                pressContinueButton()
            } else if nodeTouched == backButton {
                pressBackButton()
            } else if nodeTouched == resetButton {
                pressResetButton()
            } else if nodeTouched == menuButton {
                pressMenuButton()
            } else if nodeTouched == pauseButton { // used to setup desired position
                self.removeChildren(in: [pauseButton])
                self.addChild(resumeButton)
                if setup {
                    setup = false
                } else {
                    setup = true
                }
                print("Setting up: " + setup.description)
            } else if nodeTouched == resumeButton {
                self.removeChildren(in: [resumeButton])
                self.addChild(pauseButton)
                if setup {
                    setup = false
                } else {
                    setup = true
                }
                print("Setting up: " + setup.description)
            } else {
                let touchLocation = calculateSquareLocation(point: touch.location(in: self), locationArray: curLocationArray) // ex: ["a1","wr"]
                let name = touchLocation[1]
                if name != "invalid" {
                    if !pieceSelected && name != "" {
                        if (moveNumber % 2 != 0 && String(name[0]) == "b") || (moveNumber % 2 == 0 && String(name[0]) == "w") {
                            selectedPiece = touchLocation
                            pieceSelected = true
                            greenBorder.position = calculateSquareLocFromName(name: selectedPiece[0])
                            self.addChild(greenBorder)
                            showPossibleMoves()
                            prevLocationArray = curLocationArray
                        }
                    } else if pieceSelected {
                        if selectedPiece[0] == touchLocation[0] {
                            unselectPiece()
                        } else {
                            let moveAllowed = isMoveAllowed(pieceName: selectedPiece[1], startLocation: selectedPiece[0], endLocation: touchLocation[0], locationArray: curLocationArray, moving: true)
                            if moveAllowed {
                                moveNumber += 1
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
                                
                                if !setup {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
                                        let numLines = 3
                                        let prevFen = convertLocationArrayToFen(locationArray: prevLocationArray)
                                        let cloudEval1 = useApi(fen: prevFen, numVariations: numLines)
                                        
                                        if cloudEval1.fen == "" {
                                            self.addChild(doneLabel)
                                            print("no next move1")
                                        } else {
                                            let bestVariation = cloudEval1.pvs[0]
                                            let bestMoveString = bestVariation.moves
                                            let bestCorrectMove = bestMoveString.prefix(4)
                                            let actualMove = originalLocation + destination
                                            
                                            print("Correct: " + bestCorrectMove)
                                            print("Actual: " + actualMove)
                                            
                                            if bestCorrectMove == actualMove {
                                                moveNumber += 1
                                                self.addChild(correct)
                                                
                                                let curFen = convertLocationArrayToFen(locationArray: curLocationArray)
                                                let cloudEval2 = useApi(fen: curFen, numVariations: numLines)
                                                
                                                if cloudEval2.fen == "" {
                                                    print("no next move2")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                                        self.removeChildren(in: [correct,incorrect])
                                                        self.addChild(doneLabel)
                                                    }
                                                } else {
                                                    //let randIndex = Int.random(in: 1...cloudEval1.pvs.count)
                                                    //let selectedVariation = cloudEval2.pvs[randIndex-1]
                                                    let selectedVariation = cloudEval2.pvs[0]
                                                    let score = selectedVariation.cp
                                                    let selectedMoveString = selectedVariation.moves
                                                    let nextMove = selectedMoveString.prefix(4)
                                                    
                                                    var scoreString = "Score: " + String(score)
                                                    if abs(score) == score {
                                                        scoreString = "Score: +" + String(score)
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                                        self.removeChildren(in: [correct,incorrect])
                                                        let startSpot = convertStringLocationToIndex(stringLocation: String(nextMove.prefix(2)))
                                                        let endSpot = convertStringLocationToIndex(stringLocation: String(nextMove.suffix(2)))
                                                        curLocationArray[endSpot[0]][endSpot[1]] = curLocationArray[startSpot[0]][startSpot[1]]
                                                        curLocationArray[startSpot[0]][startSpot[1]] = ""
                                                        drawPieces(locationArray: curLocationArray)
                                                        scoreLabel.text = scoreString
                                                    }
                                                }
                                            } else {
                                                self.addChild(incorrect)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                                    self.removeChildren(in: [correct,incorrect])
                                                    curLocationArray = prevLocationArray
                                                    drawPieces(locationArray: curLocationArray)
                                                    moveNumber -= 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
