//
//  VisualizationView.swift
//  Chess4
//
//  Created by William Becht on 5/29/22.
//

import SwiftUI

struct VisualizationView: View {
    @State var locDict = convertLocationArrayToDict(locationArray: curLocationArray)
    @State var correctLocDict = convertLocationArrayToDict(locationArray: curLocationArray)
    @State var prevLocDict = convertLocationArrayToDict(locationArray: curLocationArray)
    @State var shadowRadDict = initReferenceDict()
    @State var checkDict = initReferenceDict()
    @State var shadowColorDict = initReferenceDict()
    @State var correctMoveImageDict = initReferenceDict()
    @State var wrongMoveImageDict = initReferenceDict()
    @State var clicked = false
    @State var readyToMovePieces = false
    @State var startingMoves = false
    @State var clickedPieceLocation = 999.9
    @State var clickedPiece = ""
    @State var curIndex = 0
    @AppStorage(savedInfo.progressRatingKey) var puzzleProgressRating = 600
    var usedPuzzles = [String]()
    @State var curPuzzle = Puzzle()
    @State var curStep = 0
    @State var readyForNextPuzzle = true
    let boardSize = UIScreen.main.bounds.size.width
    @Environment(\.presentationMode) var presentation
    var moveString = "d4 d5 Bf4 Nf6 e3".components(separatedBy: " ")
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var curMove = ""
    @State var showCheckMark = false
    
    
    func checkAnswer() {
        showCheckMark = true
        if locDict == correctLocDict {
            print("hey")
            showCheckMark = true
        }
    }
    
    var body: some View {
        let topLeftX = CGFloat(-7*boardSize/16)
        let topLeftY = CGFloat(-7*boardSize/16)
        let boardStep = CGFloat(boardSize/8)
        
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            if readyToMovePieces {
                VStack {
                    Spacer()
                    Spacer()
                    ZStack {
                        Image("board_green_coord")
                            .resizable()
                            .frame(width: boardSize, height: boardSize, alignment: .center)
                        
                        ForEach(locDict.sorted(by: >), id: \.key) { key, value in
                            let colNum = key.truncatingRemainder(dividingBy: 10.0)
                            let rowNum = (key-colNum)/10.0
                            
                            if value != "" {
                                Button(action: {
                                    if clicked {
                                        if key == clickedPieceLocation && value == clickedPiece {
                                            clicked = false
                                            shadowRadDict = initReferenceDict()
                                        } else {
                                            if isMoveLegal(startPiece: clickedPiece, startLocation: clickedPieceLocation, endPiece: value, endLocation: key) {
                                                clicked = false
                                                prevLocDict = locDict
                                                locDict[key] = clickedPiece
                                                locDict[clickedPieceLocation] = ""
                                                shadowRadDict[clickedPieceLocation] = 0.0
                                            }
                                        }
                                    } else {
                                        clickedPiece = value
                                        clickedPieceLocation = key
                                        clicked = true
                                        shadowRadDict[key] = 5.0
                                    }
                                }, label: {
                                    Image(value)
                                        .resizable()
                                        .frame(width: boardStep*1.01, height: boardStep*1.01, alignment: .center)
                                }).offset(x: topLeftX + boardStep*colNum, y: topLeftY + boardStep*rowNum)
                                    .shadow(color: .red, radius: shadowRadDict[key]!, x: 0, y: 0)
                            } else {
                                Button(action: {
                                    if clicked {
                                        if isMoveLegal(startPiece: clickedPiece, startLocation: clickedPieceLocation, endPiece: value, endLocation: key) {
                                            clicked = false
                                            prevLocDict = locDict
                                            locDict[key] = clickedPiece
                                            locDict[clickedPieceLocation] = ""
                                            shadowRadDict[clickedPieceLocation] = 0.0
                                        }
                                    }
                                }, label: {
                                    Rectangle()
                                        .frame(width: boardStep, height: boardStep, alignment: .center)
                                        .opacity(0)
                                }).offset(x: topLeftX + boardStep*colNum, y: topLeftY + boardStep*rowNum)
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                    if (showCheckMark == true) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                    Spacer()
                    Button {
                        checkAnswer()
                    } label: {
                        Text("Submit")
                                .fontWeight(.black)
                                .font(.headline)
                                .foregroundColor(.green)
                                .padding()
                                .overlay(
                                    Capsule(style: .circular)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                    }
                    Spacer()

                }
            } else if !startingMoves {
                Button {
                    startingMoves = true
                    let addedTime = DispatchTimeInterval.seconds(moveString.count*2)
                    DispatchQueue.main.asyncAfter(deadline: .now() + addedTime) {
                        readyToMovePieces = true
                    }
                } label: {
                    Text("Show Moves")
                }
            } else {
                let standardDate = Date(timeIntervalSinceNow: 0)
                TimelineView(PeriodicTimelineSchedule(from: Date(), by: 2)) {
                    _ in
                    let val1 = Int(Date().timeIntervalSince(standardDate))/2
                    if val1 < moveString.count {
                        Text("\(moveString[val1])")
                            .fontWeight(.black)
                            .font(.headline)
                            .foregroundColor(.white)
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
            .toolbar(content: {
               ToolbarItem (placement: .navigation)  {
                  Image(systemName: "arrow.left")
                  .foregroundColor(.white)
                  .onTapGesture {
                      self.presentation.wrappedValue.dismiss()
                  }
               }
                ToolbarItem (placement: .navigationBarTrailing)  {
                    Button {
                        print("settings?")
                    } label: {
                        Image(systemName: "gear")
                        .foregroundColor(.white)
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
    }
}
