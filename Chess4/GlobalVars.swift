//
//  GlobalVars.swift
//  Chess4
//
//  Created by William Becht on 5/5/22.
//

import Foundation
import SwiftUI

var puzzleList = [Puzzle]()

let curLocationArray: [[String]] = [
    ["br", "bn", "bb", "bq", "bk","bb", "bn", "br"],
    ["bp", "bp", "bp", "bp", "bp","bp", "bp", "bp"],
    ["", "", "", "", "","", "", ""],
    ["", "", "", "", "","", "", ""],
    ["", "", "", "", "","", "", ""],
    ["", "", "", "", "","", "", ""],
    ["wp", "wp", "wp", "wp", "wp","wp", "wp", "wp"],
    ["wr", "wn", "wb", "wq", "wk","wb", "wn", "wr"]
  ]

var usedPuzzleIds: [String] = []


