//
//  Structs.swift
//  Chess4
//
//  Created by William Becht on 5/5/22.
//

import Foundation
import SwiftUI

struct Puzzle: Codable {
    var id:String = ""
    var fen:String = ""
    var moveList:[String] = ["","","",""]
    var rating:Int = -1
    var ratingDeviation:Int = -1
    var popularity:Int = -1
    var nbPlays:Int = -1
    var themes:String = ""
    var gameURL:String = ""
}

struct Piece: Codable {
    var name:String = ""
    var color:String = ""
    var location:String = ""
    var canCastle:Bool = true
    var canEnPassant:Bool = false
}

struct savedInfo {
    static let progressRatingKey = "progressRating"
    static let usedPuzzlesKey = "usedPuzzles"
}


struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}
