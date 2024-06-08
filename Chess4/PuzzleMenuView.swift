//
//  MenuView.swift
//  Chess4
//
//  Created by William Becht on 5/6/22.
//

import SwiftUI

struct PuzzleMenuView: View {
    @AppStorage(savedInfo.progressRatingKey) var currentRating:Int = 600
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "DarkerBG")
        appearance.shadowColor = UIColor(named: "BG")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 36, weight: .black)
        ]
        appearance.largeTitleTextAttributes = attrs
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BG").ignoresSafeArea()
                VStack {
                    Text("Current Puzzle Rating: \(currentRating)")
                    NavigationLink(destination: ContentView()) {
                        Text("Go to Puzzles").multilineTextAlignment(.center)
                    }
                }
                //.navigationTitle("Puzzles")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.navigationViewStyle(.stack)
    }
}
