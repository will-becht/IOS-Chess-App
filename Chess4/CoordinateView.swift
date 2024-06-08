//
//  CoordinateView.swift
//  Chess4
//
//  Created by William Becht on 5/29/22.
//
import SwiftUI

struct CoordinateView: View {
    
    // Initializing all variables used in view
    @State var locDict = convertLocationArrayToDict(locationArray: curLocationArray)
    @State var prevLocDict = convertLocationArrayToDict(locationArray: curLocationArray)
    @State var shadowRadDict = initReferenceDict()
    @State var checkDict = initReferenceDict()
    @State var shadowColorDict = initReferenceDict()
    @State var correctMoveImageDict = initReferenceDict()
    @State var wrongMoveImageDict = initReferenceDict()
    @State var clicked = false
    @State var clickedPieceLocation = 999.9
    @State var clickedPiece = ""
    @AppStorage(savedInfo.progressRatingKey) var puzzleProgressRating = 600
    //@AppStorage(savedInfo.usedPuzzlesKey)
    var usedPuzzles = [String]()
    @State var curPuzzle = Puzzle()
    @State var curStep = 0
    @State var readyForNextPuzzle = true
    let boardSize = UIScreen.main.bounds.size.width
    @Environment(\.presentationMode) var presentation
    @State var numLives = 3
    @State var curCoord = "ZZ"
    @State var curPoints = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var timeRemaining:Double
    @State var ogTime:Double
    @State var coordBool:Bool
    
    func generateCoordinateString() -> String {
        let letters = ["a","b","c","d","e","f","g","h"]
        let numbers = ["1","2","3","4","5","6","7","8"]
        let ranLetInd = Int.random(in: 0...7)
        let ranNumInd = Int.random(in: 0...7)
        
        return letters[ranLetInd] + numbers[ranNumInd]
    }

    // defining view
    var body: some View {
        let topLeftX = CGFloat(-7*boardSize/16)
        let topLeftY = CGFloat(-7*boardSize/16)
        let boardStep = CGFloat(boardSize/8)
        ZStack {
            // Creates background color
            Color("BG")
                .ignoresSafeArea()
            VStack {
                Spacer(minLength: 90)
                HStack {
                    Text("Coordinate Practice")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer(minLength: 100)
                }.padding()
                ZStack {
                    
                    if coordBool {
                        Image("board_green_coord")
                            .resizable()
                            .frame(width: boardSize, height: boardSize, alignment: .center)
                    } else {
                        Image("board_green_coord")
                            .resizable()
                            .frame(width: boardSize, height: boardSize, alignment: .center)
                    }
                    
                    ForEach(locDict.sorted(by: >), id: \.key) { key, value in
                        let colNum = key.truncatingRemainder(dividingBy: 10.0)
                        let rowNum = (key-colNum)/10.0
                        Button(action: {
                            if curCoord != "Game Over" {
                                let chosenSquare = convertRowColToCoord(colNum: colNum, rowNum: rowNum)
                                if chosenSquare == curCoord {
                                    curCoord = generateCoordinateString()
                                    curPoints += 1
                                } else {
                                    numLives -= 1
                                }
                                
                                if numLives <= 0 {
                                    curCoord = "Game Over"
                                }
                            }
                        }, label: {
                                Rectangle()
                                    .frame(width: boardStep, height: boardStep, alignment: .center)
                                    .opacity(0)
                            }).offset(x: topLeftX + boardStep*colNum, y: topLeftY + boardStep*rowNum)
                    }
                }
                Spacer(minLength: 15)
                VStack(spacing: 0) {
                    HStack {
                        Spacer(minLength: 300)
                        VStack {
                            HStack {
                                if numLives <= 0 {
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                } else if numLives == 1 {
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                } else if numLives == 2 {
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                        .hidden()
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                } else if numLives == 3 {
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                    Image(systemName: "suit.heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            Text("Points: \(curPoints)")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                            Text("Time: \(Int(timeRemaining))")
                                .onReceive(timer, perform: { _ in
                                    if timeRemaining > 0 && curCoord != "Game Over" {
                                        timeRemaining -= 1
                                    } else {
                                        curCoord = "Game Over"
                                    }
                                })
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer(minLength: 1)
                    }
                    if curCoord == "ZZ" {
                        Text("\(curCoord)")
                            .font(.system(size: 35, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0))
                    } else {
                        Text("\(curCoord)")
                            .font(.system(size: 35, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer(minLength: 60)
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color("DarkerBG"))
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/9.0, alignment: .bottom)
                        .ignoresSafeArea()
                    
                    VStack {
                        if curCoord == "ZZ" {
                            Button {
                                curCoord = generateCoordinateString()
                                timer.connect()
                            } label: {
                                Label("Begin", systemImage: "play.circle")
                                .labelStyle(VerticalLabelStyle())
                                .foregroundColor(.white)
                            }.padding(.bottom)
                        } else {
                            Button {
                                numLives = 3
                                curPoints = 0
                                curCoord = "ZZ"
                                timeRemaining = ogTime
                                timer = Timer.publish(every: 1, on: .main, in: .common)
                            } label: {
                                Label("Reset", systemImage: "gobackward")
                                .labelStyle(VerticalLabelStyle())
                                .foregroundColor(.white)
                            }.padding(.bottom)
                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .principal) {
                Image("logoMaster")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width/2.8, height: UIScreen.main.bounds.size.width/3.0, alignment: .center)
            }
        }.navigationBarBackButtonHidden(true)
            .toolbar {
               ToolbarItem (placement: .navigation)  {
                  Image(systemName: "arrow.left")
                  .foregroundColor(.white)
                  .onTapGesture {
                      self.presentation.wrappedValue.dismiss()
                  }
               }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

func convertRowColToCoord(colNum: CGFloat, rowNum: CGFloat) -> String {
    let letterDict = [0.0:"a",1.0:"b",2.0:"c",3.0:"d",4.0:"e",5.0:"f",6.0:"g",7.0:"h"]
    let numberDict = [0.0:"8",1.0:"7",2.0:"6",3.0:"5",4.0:"4",5.0:"3",6.0:"2",7.0:"1"]
    
    let letter = letterDict[colNum]!
    let number = numberDict[rowNum]!
    
    return letter + number
}
