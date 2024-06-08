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
//import GoogleMobileAds

class SurvivalScene: SKScene {
    
    let mainGroup = DispatchGroup()
    var livesCount = 3
    /*
    var life1 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "heart.circle")!))
    var life2 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "heart.circle")!))
    var life3 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "heart.circle")!))*/
    var life1 = SKSpriteNode(imageNamed: "heart")
    var life2 = SKSpriteNode(imageNamed: "heart")
    var life3 = SKSpriteNode(imageNamed: "heart")
    var moveDelay = 0.5
    var filenames = curFileList //["london1_output"]
    let labelVal = curTitle
    var doneLabel = SKLabelNode(fontNamed: chosenFont)
    var scoreLabel = SKLabelNode(fontNamed: chosenFont)
    var highScoreLabel = SKLabelNode(fontNamed: chosenFont)
    var titleLabel = SKLabelNode(fontNamed: chosenFont)
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
    var resumeButton = SKSpriteNode(imageNamed: "resumeButton")
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
    var tapNumber = -1
    var score = 0
    var depth3List = [[String]]()
    var depth4List = [[String]]()
    var depth5List = [[String]]()
    var depth6List = [[String]]()
    var depth7List = [[String]]()
    var resumeButtonActive = false
    var curDepth = 0
    var moveNumberLabel = SKLabelNode(fontNamed: chosenFont)
    var menuButtonNew = UIButton()
    let settingsButton = UIButton()
    let resumeButtonNew = UIButton()
    let totalLevelsLabel = SKLabelNode(fontNamed: chosenFont)
    let animatedLabel = UILabel()
    
    //var interAd: GADInterstitialAd?
    
    
    
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
        let boardSize = boardMult*frame.width
        for index1 in 0...7 {
            for index2 in 0...7 {
                let item = locationArray[index1][index2]
                if item != "" {
                    let itemNode = SKSpriteNode(imageNamed: item)
                    itemNode.name = item
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
    
    // makes all the chess pieces untouchable
    func makePiecesUntouchable() {
        for index1 in 0...7 {
            for index2 in 0...7 {
                let item = curLocationArray[index1][index2]
                if item != "" {
                    let itemNode = self.childNode(withName: item)
                    itemNode?.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    // makes all the chess pieces touchable
    func makePiecesTouchable() {
        for index1 in 0...7 {
            for index2 in 0...7 {
                let item = curLocationArray[index1][index2]
                if item != "" {
                    let itemNode = self.childNode(withName: item)
                    itemNode?.isUserInteractionEnabled = true
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
        /*
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-9213997913758229/7706885423", request: GADRequest(), completionHandler: {[self] ad, error in
            if let error = error {
                print("Failed to load ad...hello")
                return
            }
            interAd = ad
        })
        
        if interAd != nil {
            interAd?.present(fromRootViewController: (self.view?.window?.rootViewController)!)
        } else {
            print("ad wasnt ready")
        }
        */
        // Disabling touches for whole screen while running
        let disableTouchNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.1),size:self.size)
        disableTouchNode.isUserInteractionEnabled = true
        disableTouchNode.zPosition = 99999
        self.addChild(disableTouchNode)
        
        
        let boardSize = boardMult*frame.width
        let boardX = 0
        let boardY = 0

        /*
        animatedLabel.frame = CGRect(x: 150, y: 300, width: 200, height: 20)
        animatedLabel.text = "Hello World!"
        animatedLabel.textColor = .white
        self.view!.addSubview(animatedLabel)
        
        UIView.animate(withDuration: 5) { [self] in
            animatedLabel.frame = CGRect(x: 150, y: 600, width: 200, height: 20)
        }*/

        
        // adding top and bottom black nav bar
        let blackSquare1 = SKSpriteNode(imageNamed: "blackSquare")
        blackSquare1.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        blackSquare1.position = CGPoint(x: 0, y: -boardSize)
        blackSquare1.alpha = 0.6
        blackSquare1.isUserInteractionEnabled = false
        self.addChild(blackSquare1)
        
        //let blackSquare2 = SKSpriteNode(imageNamed: "blackSquare")
        //blackSquare2.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        // blackSquare2.position = CGPoint(x: 0, y: boardSize)
        //  blackSquare2.alpha = 0.6
        //  blackSquare2.isUserInteractionEnabled = false
        //  self.addChild(blackSquare2)
        
        
        /*
        let blackSquare1 = UIImageView(image: UIImage(named: "blackSquare"))
        blackSquare1.isUserInteractionEnabled = true
        blackSquare1.frame = CGRect(x: 0, y: -boardSize/8, width: boardSize*1.5, height: boardSize/4)
        blackSquare1.layer.zPosition = -99999
        self.view!.addSubview(blackSquare1)*/
        
        // Creating board size and position; adding to screen
        board.position = CGPoint(x: boardX, y: boardY)
        board.size = CGSize(width: boardSize, height: boardSize)
        self.addChild(board)
        
        // adjusting button size and adding to screen
        continueButton.size = CGSize(width: continueButton.size.width * 0.6, height: continueButton.size.height*0.6)
        continueButton.position = CGPoint(x: boardSize/4, y: -boardSize/1.3)
        //self.addChild(continueButton)
        
        backButton.size = CGSize(width: backButton.size.width * 0.21, height: backButton.size.height*0.21)
        backButton.position = CGPoint(x: -boardSize/4, y: -boardSize/1.3)
        //self.addChild(backButton)
        
        resetButton.size = CGSize(width: resetButton.size.width * 0.35, height: resetButton.size.height*0.35)
        resetButton.position = CGPoint(x: 0, y: -boardSize/1.03)
        self.addChild(resetButton)
        
        
        redCircle.size = CGSize(width: redCircle.size.width * 0.2, height: redCircle.size.height*0.2)
        redCircle.position = CGPoint(x: 0, y: -boardSize/1.5)
        
        greenCircle.size = CGSize(width: greenCircle.size.width * 0.22, height: greenCircle.size.height*0.22)
        greenCircle.position = CGPoint(x: 0, y: -boardSize/1.5)
        
        greenBorder.scale(to: CGSize(width: boardSize/8, height: boardSize/8))
        //greenBorder.position = CGPoint(x: -boardSize/16, y: -boardSize/2 + (boardSize/16))
        
        nextMoveListButton.size = CGSize(width: nextMoveListButton.size.width * 0.367, height: nextMoveListButton.size.height*0.367)
        nextMoveListButton.position = CGPoint(x: boardSize/8, y: boardSize/1.3)
        //self.addChild(nextMoveListButton)
        
        backMoveListButton.size = CGSize(width: backMoveListButton.size.width * 0.265, height: backMoveListButton.size.height * 0.265)
        backMoveListButton.position = CGPoint(x: -boardSize/8, y: boardSize/1.3)
        //self.addChild(backMoveListButton)
        
        let stdFontSize = 35.0
        let totalLevelx = -boardSize/3.1
        let moveNumberx = -boardSize/3.1
        let highScorex = -boardSize/3.1
        let scorex = -boardSize/3.1
        
        let totalLevely = -boardSize/1.2
        let highScorey = -boardSize/1.28
        let moveNumbery = -boardSize/1.66
        let scorey = -boardSize/1.8
        
        moveNumberLabel.fontSize = stdFontSize
        moveNumberLabel.position = CGPoint(x: totalLevelx, y: moveNumbery)
        if fenLinesList.isEmpty {
            moveNumberLabel.text = "Move: 0/0"
        } else {
            let leftNum = (tapNumber+1)/2
            let rightNum = (fenLinesList[listNumber].count+1)/2
            moveNumberLabel.text = "Move: " + String(leftNum+1) + "/" + String(rightNum)
        }
        self.addChild(moveNumberLabel)
        
        scoreLabel.fontSize = stdFontSize
        scoreLabel.position = CGPoint(x: totalLevelx, y: scorey)
        scoreLabel.text = "Score: " + String(score)
        self.addChild(scoreLabel)
        
        highScoreLabel.fontSize = stdFontSize
        highScoreLabel.position = CGPoint(x: totalLevelx, y: highScorey)
        highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "HighScore"))
        self.addChild(highScoreLabel)
        
        titleLabel.position = CGPoint(x: 0, y: boardSize/1.47)
        /*titleLabel.text = labelVal + " (" + String(listNumber+1) + "/" + String(fenLinesList.count) + ")"*/
        titleLabel.text = "Level " + String(listNumber+1)
        titleLabel.fontSize = 70
        self.addChild(titleLabel)
        
        doneLabel.fontSize = 50
        doneLabel.text = "Game Over"
        doneLabel.position = CGPoint(x: 0, y: -boardSize/1.6)
        
        let buttonSize = 30.0
        let largeConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc = UIImage(systemName: "house", withConfiguration: largeConfig)
        menuButtonNew.setImage(largeBoldDoc, for: .normal)
        //menuButtonNew.frame = CGRect(x: frame.maxX * 0.195, y: 0.93*frame.maxY, width: buttonSize, height: buttonSize) for iphone xr
        menuButtonNew.frame = CGRect(x: frame.maxX * 0.17, y: 0.885*frame.maxY, width: buttonSize, height: buttonSize)
        menuButtonNew.layer.cornerRadius = 0.5 * menuButtonNew.bounds.size.width
        menuButtonNew.clipsToBounds = true
        menuButtonNew.addTarget(self, action: #selector(menuButtonNewClicked(_ :)), for: .touchUpInside)
        menuButtonNew.tintColor = .white
        self.view!.addSubview(menuButtonNew)
        
        
        // CREATING SETTINGS BUTTON
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc2 = UIImage(systemName: "switch.2", withConfiguration: largeConfig2)
        settingsButton.setImage(largeBoldDoc2, for: .normal)
        //settingsButton.frame = CGRect(x: frame.maxX * 0.73, y: 0.93*frame.maxY, width: buttonSize, height: buttonSize) for iphone xr
        settingsButton.frame = CGRect(x: frame.maxX * 0.71, y: 0.885*frame.maxY, width: buttonSize, height: buttonSize)
        settingsButton.layer.cornerRadius = 0.5 * settingsButton.bounds.size.width
        settingsButton.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked(_ :)), for: .touchUpInside)
        settingsButton.tintColor = .white
        self.view!.addSubview(settingsButton)
        
        
        // CREATING RESUME BUTTON
        let buttonSize3 = 50.0
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: buttonSize3, weight: .medium, scale: .default)
        let largeBoldDoc3 = UIImage(systemName: "play.circle", withConfiguration: largeConfig3)
        resumeButtonNew.setImage(largeBoldDoc3, for: .normal)
        resumeButtonNew.frame = CGRect(x: 172, y: 700, width: buttonSize3, height: buttonSize3)
        resumeButtonNew.layer.cornerRadius = 0.5 * settingsButton.bounds.size.width
        resumeButtonNew.clipsToBounds = true
        resumeButtonNew.addTarget(self, action: #selector(resumeButtonClicked(_ :)), for: .touchUpInside)
        resumeButtonNew.tintColor = .green
        resumeButtonNew.setTitle("See Solution", for: .normal)
        resumeButtonNew.titleLabel?.font = UIFont(name: "Esteban", size: 10)
        
        
        correct.size = CGSize(width: correct.size.width * 0.15, height: correct.size.height * 0.15)
        correct.position = CGPoint(x: 0, y: boardSize/1.7)
        
        incorrect.size = CGSize(width: incorrect.size.width * 0.2, height: incorrect.size.height * 0.2)
        incorrect.position = CGPoint(x: 0, y: boardSize/1.7)
        
        life1.size = CGSize(width: boardSize/16, height: boardSize/16)
        life2.size = life1.size
        life3.size = life1.size
        life1.position = CGPoint(x: boardSize/2 - (1.2*life1.size.width/2), y: -boardSize/2-(1.4*life1.size.height/2))
        life2.position = CGPoint(x: life1.position.x - life2.size.width, y: life1.position.y)
        life3.position = CGPoint(x: life2.position.x - life3.size.width, y: life1.position.y)
        
        self.addChild(life1)
        self.addChild(life2)
        self.addChild(life3)
        

        
        
        // drawing initial setup of pieces
        drawPieces(locationArray: originalSetup)
        
        
        // adding black tint

        let blackSquare = SKSpriteNode(imageNamed: "blackSquare")
        blackSquare.size = CGSize(width: boardSize, height: boardSize)
        blackSquare.position = CGPoint(x: boardX, y: boardY)
        blackSquare.alpha = 0.8
        self.addChild(blackSquare)
        
        // showing level number
        let levelLabel = SKLabelNode(fontNamed: chosenFont)
        levelLabel.fontSize = 55
        levelLabel.text = "Level " + String(listNumber+1)
        levelLabel.position = blackSquare.position
        self.addChild(levelLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.removeChildren(in: [levelLabel,blackSquare,disableTouchNode])
        }
        
        // reading in text file
        for fn in filenames {
            var depth = 0
            let curFenLines = readInFenText(filename: fn)
            //fenLinesList.append(curFenLines)
            
            let curFn = fn
            if let range: Range<String.Index> = curFn.range(of: "Depth") {
                let index: Int = curFn.distance(from: curFn.startIndex, to: range.lowerBound)
                depth = Int(String(curFn[index+5]))!
            }
            
            if depth == 3 {
                depth3List.append(curFenLines)
            } else if depth == 4 {
                depth4List.append(curFenLines)
            } else if depth == 5 {
                depth5List.append(curFenLines)
            } else if depth == 6 {
                depth6List.append(curFenLines)
            } else if depth == 7 {
                depth7List.append(curFenLines)
            }
        }
        shuffleOrder()
        

        
        totalLevelsLabel.fontSize = stdFontSize
        totalLevelsLabel.position = CGPoint(x: totalLevelx, y: totalLevely)
        totalLevelsLabel.text = "Total Levels: " + String(fenLinesList.count)
        self.addChild(totalLevelsLabel)
    }
    
    
    func unselectPiece() {
        pieceSelected = false
        self.removeChildren(in: [greenBorder])
        resetButton.removeAllChildren()
    }
    
    func shuffleOrder() {
        depth3List.shuffle()
        //depth4List.shuffle()
        //depth5List.shuffle()
        //depth6List.shuffle()
        //depth7List.shuffle()
        fenLinesList = depth3List + depth4List + depth5List + depth6List + depth7List
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
        }
    }
    
    func pressBackButton() {
        unselectPiece()
        if tapNumber >= 1 {
            tapNumber -= 1
            curLocationArray = convertFenToLocationArray(fenLine: fenLines[tapNumber])
            drawPieces(locationArray: curLocationArray)
        } else if tapNumber == 0 {
            tapNumber -= 1
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
        }
    }
    
    func removeThingsGood() {
        self.removeChildren(in: [correct,incorrect])
        pressContinueButton()
        let leftNum = (tapNumber+1)/2
        let rightNum = (fenLinesList[listNumber].count+1)/2
        moveNumberLabel.text = "Move: " + String(leftNum+1) + "/" + String(rightNum)
        //moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
    }
    
    func removeThingsBad() {
        self.removeChildren(in: [correct,incorrect])
        pressBackButton()
        livesCount -= 1
        adjustLives()
    }
    

    func pressNextMoveListButton() {
        unselectPiece()
        if listNumber+1 < fenLinesList.count {
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            tapNumber = -1
            listNumber += 1
            titleLabel.text = "Level " + String(listNumber+1)
        }
        if livesCount > 0 {
            score += 1
            if score > UserDefaults.standard.integer(forKey: "HighScore") {
                UserDefaults.standard.set(score, forKey: "HighScore")
                highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "HighScore"))
            }
            scoreLabel.text = "Score: " + String(score)
        }
        let leftNum = (tapNumber+1)/2
        let rightNum = (fenLinesList[listNumber].count+1)/2
        moveNumberLabel.text = "Move: " + String(leftNum+1) + "/" + String(rightNum)
        //moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
    }
    
    func pressBackMoveListButton() {
        unselectPiece()
        if listNumber > 0 {
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            tapNumber = -1
            listNumber -= 1
            titleLabel.text = "Level " + String(listNumber+1)
        }
    }
    
    func pressResetButton() {
        resetButton.removeAllChildren()
        resumeButtonNew.removeFromSuperview()
        resumeButtonActive = false
        shuffleOrder()
        curLocationArray = originalSetup
        drawPieces(locationArray: curLocationArray)
        tapNumber = -1
        unselectPiece()
        livesCount = 3
        adjustLives()
        listNumber = 0
        titleLabel.text = "Level " + String(listNumber+1)
        score = 0
        scoreLabel.text = "Score: " + String(score)
        let leftNum = (tapNumber+1)/2
        let rightNum = (fenLinesList[listNumber].count+1)/2
        moveNumberLabel.text = "Move: " + String(leftNum+1) + "/" + String(rightNum)
        //moveNumberLabel.text = "Move: " + String(tapNumber+1) + "/" + String(fenLinesList[listNumber].count)
        showLevel(first: true)
    }
    
    func adjustLives() {
        self.removeChildren(in: [life1,life2,life3,doneLabel])
        resumeButtonNew.removeFromSuperview()
        if livesCount == 3 {
            self.addChild(life1)
            self.addChild(life2)
            self.addChild(life3)
        } else if livesCount == 2 {
            self.addChild(life1)
            self.addChild(life2)
        } else if livesCount == 1 {
            self.addChild(life1)
        } else {
            self.addChild(doneLabel)
            resumeButtonActive = true
            self.view!.addSubview(resumeButtonNew)
        }
    }
    
    func removeButtons() {
        menuButtonNew.removeFromSuperview()
        settingsButton.removeFromSuperview()
        resumeButtonNew.removeFromSuperview()
    }
    
    
    @objc func menuButtonNewClicked(_: UIButton) {
        removeButtons()
        let nextScene = GameScene(fileNamed: "MenuScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    
    @objc func settingsButtonClicked(_: UIButton) {
        removeButtons()
        lastScene = "SurvivalScene"
        let nextScene = GameScene(fileNamed: "SettingsScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    @objc func resumeButtonClicked(_: UIButton) {
        makePiecesUntouchable()
        
        resumeButtonNew.isHidden = true
        resetButton.isHidden = true
        
        if resumeButtonActive {
            curLocationArray = originalSetup
            drawPieces(locationArray: curLocationArray)
            
            var index = 1
            for line in fenLines {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(index)) { [self] in
                    curLocationArray = convertFenToLocationArray(fenLine: line)
                    drawPieces(locationArray: curLocationArray)
                    
                    if line == fenLines.last {
                        resumeButtonNew.isHidden = false
                        resetButton.isHidden = false
                    }
                }
                index += 1
            }
        }
        makePiecesTouchable()
    }
    
    func showLevel(first: Bool) {
        
        // Disabling touches for whole screen while running
        let disableTouchNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.1),size:self.size)
        disableTouchNode.isUserInteractionEnabled = true
        disableTouchNode.zPosition = 99999
        self.addChild(disableTouchNode)
        
        // adding black tint
        let boardSize = boardMult*frame.width
        let boardX = 0
        let boardY = 0
        let blackSquare = SKSpriteNode(imageNamed: "blackSquare")
        blackSquare.size = CGSize(width: boardSize, height: boardSize)
        blackSquare.position = CGPoint(x: boardX, y: boardY)
        blackSquare.alpha = 0.8
        self.addChild(blackSquare)
        
        // showing level number
        let levelLabel = SKLabelNode(fontNamed: chosenFont)
        levelLabel.fontSize = 55
        levelLabel.text = "Level " + String(listNumber+2)
        if first {
            levelLabel.text = "Level " + String(listNumber+1)
        }
        levelLabel.position = blackSquare.position
        self.addChild(levelLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.removeChildren(in: [levelLabel,blackSquare,disableTouchNode])
            if !first {
                pressNextMoveListButton()
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if livesCount > 0 {
                self.removeChildren(in: [doneLabel])
            }
            self.removeChildren(in: [correct,incorrect])
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) { [self] in
                showLevel(first: false)
            }
        }
    }
}
    

/*
curDepth = Int(ceil(Double(fenLines.count)/2.0))
print(curDepth)
*/

