//
//  SplashView.swift
//  Chess4
//
//  Created by William Becht on 5/15/22.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.000001
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
                Color("DarkerBG")
                    .ignoresSafeArea()
                VStack {
                    Image("logoMaster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        //puzzleList = readPuzzleFile(filename: "bestPuzzles") async time should be 0.1
                        self.isActive = true
                    }
                }
            }
        }
    }
}
