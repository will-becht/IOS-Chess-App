//
//  oldCode.swift
//  Chess4
//
//  Created by William Becht on 5/6/22.
//

import Foundation


 //
 //  MainView.swift
 //  Chess4
 //
 //  Created by William Becht on 5/3/22.
 //

 import SwiftUI

 struct MainViewOld1: View {
     @State var puzzlesLoaded = false

     var body: some View {
         
         if puzzlesLoaded {
             TabView {
                 PuzzleMenuView()
                     .tabItem {
                         Label("Puzzles", systemImage: "puzzlepiece.extension")
                     }
                 LearnMenuView()
                     .tabItem {
                         Label("Learn", systemImage: "studentdesk")
                     }
                 SettingsMenuView()
                     .tabItem {
                         Label("Settings", systemImage: "gear")
                     }
             }.tabViewStyle(backgroundColor: UIColor(named: "DarkerBG"), itemColor: nil, selectedItemColor: nil, badgeColor: nil)
             /**
             TabView {
                 ContentView()
                     .tabItem {
                         Label("Board", systemImage: "list.dash")
                     }
             }.tabViewStyle()**/
         } else {
             LoadingScreenView()
                 .onAppear {
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                         puzzlesLoaded = true
                     }
                 }
         }
     }
 }
         //.tabViewStyle(backgroundColor: UIColor.orange, itemColor: UIColor.red, selectedItemColor: UIColor.green, badgeColor: UIColor.purple)


  /**   .opacity(finished ? 0 : 1)
     .onAppear {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             readPuzzles()
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             finished = true
         }
     }
 **/

