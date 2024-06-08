//
//  MainView.swift
//  Chess4
//
//  Created by William Becht on 5/3/22.
//

import SwiftUI

struct MainViewOld: View {
    @State var puzzlesLoaded = false

    var body: some View {
        
        if puzzlesLoaded {
            TabBarView()
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



struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}


/*
 ZStack {
     Color("BG")
         .ignoresSafeArea()
     VStack {
         Spacer()
         NavigationLink(destination: CoordinateView()) {
             Text("Coordinate Practice")
                     .fontWeight(.black)
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .overlay(
                         Capsule(style: .circular)
                             .stroke(Color.white, lineWidth: 2)
                     )
             
         }
         Spacer()
         NavigationLink(destination: OpeningsView()) {
             Text("Study Openings")
                     .fontWeight(.black)
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .overlay(
                         Capsule(style: .circular)
                             .stroke(Color.white, lineWidth: 2)
                     )
         }
         Spacer()
         NavigationLink(destination: VisualizationView()) {
             Text("Visualization Practice")
                     .fontWeight(.black)
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .overlay(
                         Capsule(style: .circular)
                             .stroke(Color.white, lineWidth: 2)
                     )
         }
         Spacer()
         Spacer()
         Spacer()
     }
 }
         .tabItem { Label("Learn", systemImage: "studentdesk") }
         .tag(Tabs.tab2)
 */
