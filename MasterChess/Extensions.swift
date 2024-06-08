//
//  Extensions.swift
//  Chess4
//
//  Created by William Becht on 5/3/22.
//

import Foundation
import SwiftUI

extension View {
  func tabViewStyle(backgroundColor: UIColor? = nil,
                    itemColor: UIColor? = nil,
                    selectedItemColor: UIColor? = nil,
                    badgeColor: UIColor? = nil) -> some View {
    onAppear {
      let itemAppearance = UITabBarItemAppearance()
        if itemColor != nil {
        itemAppearance.normal.iconColor = itemColor
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: itemColor ?? UIColor.white
        ]
      }
      if selectedItemColor != nil {
        itemAppearance.selected.iconColor = selectedItemColor
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedItemColor ?? UIColor.white
        ]
      }
      if badgeColor != nil {
        itemAppearance.normal.badgeBackgroundColor = badgeColor
        itemAppearance.selected.badgeBackgroundColor = badgeColor
      }

      let appearance = UITabBarAppearance()
      if backgroundColor != nil {
          appearance.backgroundColor = backgroundColor
      }

      appearance.stackedLayoutAppearance = itemAppearance
      appearance.inlineLayoutAppearance = itemAppearance
      appearance.compactInlineLayoutAppearance = itemAppearance

      UITabBar.appearance().standardAppearance = appearance
      if #available(iOS 15.0, *) {
        UITabBar.appearance().scrollEdgeAppearance = appearance
      }
    }
  }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
