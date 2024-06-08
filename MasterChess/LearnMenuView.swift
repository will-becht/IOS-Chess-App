//
//  LessonsView.swift
//  Chess4
//
//  Created by William Becht on 5/6/22.
//

import SwiftUI

struct LearnMenuView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BG")
                    .ignoresSafeArea()
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}
