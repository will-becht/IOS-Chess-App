//
//  ContentView.swift
//  Chess
//
//  Created by William Becht on 3/30/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ViewLearn()
                .tabItem() {
                    Image(systemName: "studentdesk")
                    Text("Learn")
                }
            ViewSurvival()
                .tabItem() {
                    Image(systemName: "exclamationmark.square")
                    Text("Survival")
                }
            ViewBot()
                .tabItem() {
                    Image(systemName: "desktopcomputer")
                    Text("Bot")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
