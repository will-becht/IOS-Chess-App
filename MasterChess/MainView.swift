//
//  MainView3.swift
//  Chess4
//
//  Created by William Becht on 5/8/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentation
    @State private var CoordBool = true
    @State private var blackWhiteCoord = true
    @State var sliderValue: Double = 30
    
    init() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(named: "DarkerBG")
        navAppearance.shadowColor = UIColor(named: "BG")
        let navAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 36, weight: .black)
        ]
        navAppearance.largeTitleTextAttributes = navAttrs
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
    
    @State var tabSelection: Tabs = .tab1
    var body: some View {
        NavigationView{
            TabView(selection: $tabSelection) {
                
                /**
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    VStack {
                        Text("Current Puzzle Rating: ")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        Text("Maximum Puzzle Rating: ")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        
                        NavigationLink(destination: ContentView()) {
                            Text("Begin")
                                .padding()
                                .foregroundColor(Color.green)
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .overlay(
                                    Capsule(style: .circular)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                }
                        .tabItem { Label("Puzzles", systemImage: "puzzlepiece.extension") }
                        .tag(Tabs.tab1)
                **/
                
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    VStack {
                        NavigationLink(destination: VisualizationQuizView()) {
                            Text("Begin")
                                .padding()
                                .foregroundColor(Color.green)
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .overlay(
                                    Capsule(style: .circular)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                }
                        .tabItem { Label("Play Blind", systemImage: "eye.slash") }
                        .tag(Tabs.tab1)
                
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    VStack {
                        NavigationLink(destination: VisualizationView()) {
                            Text("Tap for view")
                                .foregroundColor(Color.white)
                        }
                    }
                }
                        .tabItem { Label("Visualize", systemImage: "brain.head.profile") }
                        .tag(Tabs.tab2)
                
                
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    VStack {
                        Toggle(isOn: $CoordBool) {
                            Text("Coordinates")
                                .foregroundColor(Color.green)
                        }.padding()
                        VStack {
                            HStack {
                                Text("Timer")
                                Image(systemName: "minus")
                                Slider(value: $sliderValue, in: 15...120, step: 15)
                                    .accentColor(Color.green)
                                Image(systemName: "plus")
                            }.foregroundColor(Color.green)
                            Text("\(sliderValue, specifier: "%.0f") seconds")
                                .foregroundColor(Color.green)
                        }.padding()
                        NavigationLink(destination: CoordinateView(timeRemaining: sliderValue, ogTime: sliderValue, coordBool: CoordBool)) {
                            Text("Begin")
                                .fontWeight(.black)
                                .font(.headline)
                                .foregroundColor(.green)
                                .padding()
                                .overlay(
                                    Capsule(style: .circular)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                
                        }.padding()
                    }
                }
                        .tabItem { Label("Coordinates", systemImage: "scope") }
                        .tag(Tabs.tab3)
                
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    VStack{
                    }
                }
                        .tabItem { Label("Settings", systemImage: "gear") }
                        .tag(Tabs.tab4)
            }
            .navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))
            .tabViewStyle(backgroundColor: UIColor(named: "DarkerBG"), itemColor: nil, selectedItemColor: nil, badgeColor: nil)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("logoMaster")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.size.width/2.8, height: UIScreen.main.bounds.size.width/3.0, alignment: .center)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    enum Tabs{
        case tab1, tab2, tab3, tab4
    }
    
    func returnNaviBarTitle(tabSelection: Tabs) -> String {
        switch tabSelection {
            case .tab1: return "Play Blind" //Puzzles
            case .tab2: return "Visualize"
            case .tab3: return "Coordinates"
            case .tab4: return "Settings"
        }
    }
}


struct NavigatedView: View {
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            Text("Hi! This is the NavigatedView")
                .navigationBarTitle("NavigatedView")
                .toolbar {
                    ToolbarItemGroup(placement: .principal) {
                        Image("logoMaster")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width/2.8, height: UIScreen.main.bounds.size.width/3.0, alignment: .center)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar(content: {
                   ToolbarItem (placement: .navigation)  {
                      Image(systemName: "arrow.left")
                      .foregroundColor(.white)
                      .onTapGesture {
                          self.presentation.wrappedValue.dismiss()
                      }
                   }
                })
        }
    }
}
