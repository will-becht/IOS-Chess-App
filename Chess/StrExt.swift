//
//  StrExt.swift
//  Chess
//
//  Created by William Becht on 3/2/22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
