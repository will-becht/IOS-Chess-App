//
//  LoadingScreen.swift
//  Chess4
//
//  Created by William Becht on 5/5/22.
//

import SwiftUI

struct LoadingScreenView: View {
    @State var finished: Bool = false
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            Image("wp")
        }
    }
}

