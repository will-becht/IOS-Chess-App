//
//  TransitionCoordinator.swift
//  Chess4
//
//  Created by William Becht on 5/15/22.
//

import SwiftUI

final class AppFlowCoordinator: ObservableObject {
    @Published var activeFlow: Flow = .login
    
    func showLoginView() {
        withAnimation {
            activeFlow = .login
        }
    }
    
    func showMainView() {
        withAnimation {
            activeFlow = .main
        }
    }
}

extension AppFlowCoordinator {
    enum Flow {
        case login, main
    }
}
