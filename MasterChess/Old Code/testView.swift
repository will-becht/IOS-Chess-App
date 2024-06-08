//
//  testView.swift
//  Chess4
//
//  Created by William Becht on 5/6/22.
//

import SwiftUI

struct testView: View {
    @State private var tabBar: UITabBar! = nil

    var body: some View {
        NavigationView {
            NavigationLink(destination:
                SettingsMenuView()
                    .onAppear { self.tabBar.isHidden = true }     // !!
                    .onDisappear { self.tabBar.isHidden = false } // !!
            ) {
                Text("Go to...")
            }
            .navigationBarTitle("FirstTitle", displayMode: .inline)
        }.navigationViewStyle(.stack)
        .background(TabBarAccessor { tabbar in   // << here !!
            self.tabBar = tabbar
        })
    }
}

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}
