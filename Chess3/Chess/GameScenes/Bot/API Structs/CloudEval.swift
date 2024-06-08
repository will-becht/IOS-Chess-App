//
//  CloudEval.swift
//  Chess
//
//  Created by William Becht on 3/18/22.
//

import Foundation

struct CloudEval: Codable {
    var fen:String = ""
    var knodes:Int = 0
    var pvs:[Variation] = [Variation]()
    
}
