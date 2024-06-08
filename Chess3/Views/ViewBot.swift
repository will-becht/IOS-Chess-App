//
//  ViewBot.swift
//  Chess
//
//  Created by William Becht on 3/30/22.
//

import SwiftUI

struct ViewBot: View {
    var body: some View {
        ZStack {
            Color.blue
            
            Image(systemName: "desktopcomputer")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct ViewBot_Previews: PreviewProvider {
    static var previews: some View {
        ViewBot()
    }
}
