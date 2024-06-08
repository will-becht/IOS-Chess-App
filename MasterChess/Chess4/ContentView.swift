//
//  ContentView.swift
//  Chess4
//
//  Created by William Becht on 4/16/22.
//

/*
for index1 in 0...7 {
    for index2 in 0...7 {
        let item = locationArray[index1][index2]
        if item != "" {
*/
import SwiftUI

struct ContentView: View {
    
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
    
    // function to show next move
    func nextMove(curLocDict: [CGFloat:String]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            locDict = makeNextmove(step: curStep, moveList: curPuzzle.moveList, curLocDict: locDict)
            curStep += 1
        }
    }
    
    // reset button pressed function
    func resetButton() {
        curPuzzle = Puzzle()
        readyForNextPuzzle = true
        clicked = false
        shadowRadDict = initReferenceDict()
        locDict = convertLocationArrayToDict(locationArray: curLocationArray)
        puzzleProgressRating = 600
        curStep = 0
        usedPuzzleIds = []
    }
    
    // setting up for next puzzle
    func initializeNextPuzzle() {
        clicked = false
        shadowRadDict = initReferenceDict()
        curStep = 0
        usedPuzzleIds.append(curPuzzle.id)
        curPuzzle = findPuzzle(rating: puzzleProgressRating, puzzleList: puzzleList)
        locDict = convertFenToLocDict(fen: curPuzzle.fen)
        nextMove(curLocDict: locDict)
        readyForNextPuzzle = false
    }
    
    // runs when solution button is touched
    func showSolution() {
        let origCurStep = curStep
        let origLocDict = locDict
        curStep = 0
        var ind = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(ind)) {
            if curStep+1 == curPuzzle.moveList.count {// puzzle done
                curStep = origCurStep
                locDict = origLocDict
            } else {
                nextMove(curLocDict: locDict)
            }
            ind += 1
        }
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
                    Text("Progress Rating:  \(puzzleProgressRating)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer(minLength: 100)
                }.padding()
                ZStack {
                    Image("board_green")
                        .resizable()
                        .frame(width: boardSize, height: boardSize, alignment: .center)
                    
                    ForEach(locDict.sorted(by: >), id: \.key) { key, value in
                        let colNum = key.truncatingRemainder(dividingBy: 10.0)
                        let rowNum = (key-colNum)/10.0
                        let correctLocDict = makeNextmove(step: curStep, moveList: curPuzzle.moveList, curLocDict: locDict)
                        
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
                                            
                                            if locDict == correctLocDict {
                                                correctMoveImageDict[key] = 1.0
                                                if curStep+1 == curPuzzle.moveList.count {
                                                    readyForNextPuzzle = true
                                                    puzzleProgressRating += 15
                                                } else {
                                                    curStep += 1
                                                    nextMove(curLocDict: locDict)
                                                }
                                            } else { // wrong
                                                wrongMoveImageDict[key] = 1.0
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                                    locDict = prevLocDict
                                                }
                                            }
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
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                                            if locDict == correctLocDict {
                                                correctMoveImageDict[key] = 1.0
                                                if curStep+1 == curPuzzle.moveList.count { // correct, ready for next puzzle
                                                    readyForNextPuzzle = true
                                                    puzzleProgressRating += 15
                                                } else { // correct, showing next opponent move
                                                    curStep += 1
                                                    nextMove(curLocDict: locDict)
                                                }
                                            } else { // wrong move
                                                wrongMoveImageDict[key] = 1.0
                                                locDict = prevLocDict
                                            }
                                        }
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
                
                
                
                
                Spacer(minLength: 25)
                if curPuzzle.rating != -1 {
                    Text("Current Puzzle Rating: \(curPuzzle.rating)")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    Text(" ")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                if curPuzzle.moveList.first != "" {
                    if readyForNextPuzzle {
                        Text("Done")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    } else {
                        let colorDict = ["w":"Black", "b":"White"]
                        Text("\(colorDict[curPuzzle.fen.components(separatedBy: " ")[1]]!) to Move")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                } else {
                    Text(" ")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer(minLength: 105)
                
                ZStack {
                    Rectangle()
                        .fill(Color("DarkerBG"))
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/9.0, alignment: .bottom)
                        .ignoresSafeArea()
                    
                    VStack {
                        if curPuzzle.rating == -1 {
                            Button {
                                initializeNextPuzzle()
                            } label: {
                                Label("Begin", systemImage: "play.circle")
                                .labelStyle(VerticalLabelStyle())
                                .foregroundColor(.white)
                            }.padding(.bottom)
                        } else {
                            HStack {
                                Spacer()
                                Button {
                                    showSolution()
                                } label: {
                                        Label("Solution", systemImage: "star.circle")
                                        .labelStyle(VerticalLabelStyle())
                                        .foregroundColor(.white)
                                }

                                Spacer()
                                Button {
                                    initializeNextPuzzle()
                                } label: {
                                    if readyForNextPuzzle {
                                        Label("Next", systemImage: "arrow.forward.circle")
                                        .labelStyle(VerticalLabelStyle())
                                        .foregroundColor(.white)
                                    } else {
                                        Label("Skip", systemImage: "arrow.forward.circle")
                                        .labelStyle(VerticalLabelStyle())
                                        .foregroundColor(.white)
                                    }
                                }
                                Spacer()
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
            .toolbar(content: {
               ToolbarItem (placement: .navigation)  {
                  Image(systemName: "arrow.left")
                  .foregroundColor(.white)
                  .onTapGesture {
                      // code to dismiss the view
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



// Defining function to make locDict move based on moveList and previous locDict
func makeNextmove(step: Int, moveList: [String], curLocDict: [CGFloat:String]) -> [CGFloat:String] {
    var locDict = curLocDict
    let move = moveList[step]
    if move == "" { // when no puzzle is shown, just show regular setup
        return locDict
    }
    let startColVal = String(move[0])
    let startRowVal = String(move[1])
    let endColVal = String(move[2])
    let endRowVal = String(move[3])
    
    var letterDict = [String:CGFloat]()
    var numberDict = [String:CGFloat]()
    letterDict = ["a":0.0,"b":1.0,"c":2.0,"d":3.0,"e":4.0,"f":5.0,"g":6.0,"h":7.0]
    numberDict = ["8":0.0,"7":1.0,"6":2.0,"5":3.0,"4":4.0,"3":5.0,"2":6.0,"1":7.0]
    let startColNum = letterDict[startColVal]
    let startRowNum = numberDict[startRowVal]!
    let endColNum = letterDict[endColVal]
    let endRowNum = numberDict[endRowVal]
    
    let movingPiece = curLocDict[startRowNum*10.0 + startColNum!]
    locDict[endRowNum!*10.0 + endColNum!] = movingPiece
    locDict[startRowNum*10.0 + startColNum!] = ""
    
    // auto-queening when pawn reaches last ranks for white and black
    if movingPiece == "wp" && endRowNum == 0.0 {
        locDict[endRowNum!*10.0 + endColNum!] = "wq"
    } else if movingPiece == "bp" && endRowNum == 7.0 {
        locDict[endRowNum!*10.0 + endColNum!] = "bq"
    }
    
    return locDict
}

func isMoveLegal(startPiece:String, startLocation:CGFloat, endPiece:String, endLocation:CGFloat) -> Bool {
    let startColor = String(startPiece[0])
    //let startName = String(startPiece[1])
    var endColor = ""
    //var endName = ""
    if endPiece != "" {
        endColor = String(endPiece[0])
        //endName = String(endPiece[1])
    }
    
    if startColor == endColor {
        return false
    }
    return true
}



// Preview Current View
/**
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}**/
