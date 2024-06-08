//
//  testView2.swift
//  Chess4
//
//  Created by William Becht on 5/6/22.
//
import SwiftUI

struct TabBarView: View {
    enum Tab: Int {
        case first, second
    }
    
    @State private var selectedTab = Tab.first
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if selectedTab == .first {
                    SettingsMenuView()
                }
                else if selectedTab == .second {
                    NavigationView {
                        VStack(spacing: 0) {
                            LearnView()
                            tabBarView
                        }
                    }.navigationViewStyle(.stack)
                }
            }
            
            if selectedTab != .second {
                tabBarView
            }
        }
    }
    
    var tabBarView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 20) {
                tabBarItem(.first, title: "Puzzles", icon: "hare", selectedIcon: "hare.fill")
                tabBarItem(.second, title: "Learn", icon: "tortoise", selectedIcon: "tortoise.fill")
            }
            .padding(.top, 8)
        }
        .frame(height: 50)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    func tabBarItem(_ tab: Tab, title: String, icon: String, selectedIcon: String) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 3) {
                VStack {
                    Image(systemName: (selectedTab == tab ? selectedIcon : icon))
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == tab ? .primary : .black)
                }
                .frame(width: 55, height: 28)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(selectedTab == tab ? .primary : .black)
            }
        }
        .frame(width: 65, height: 42)
        .onTapGesture {
            selectedTab = tab
        }
    }
}

struct LearnView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: SettingsMenuView()) {
                Text("Second View, tap to navigate")
                    .font(.headline)
            }
        }
        .navigationTitle("Second title")
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.orange)
    }
}

