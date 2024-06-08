//
//  test3.swift
//  Chess4
//
//  Created by William Becht on 5/8/22.
//

import SwiftUI


struct test3: View {
    @Environment(\.presentationMode) var presentation

    var body: some View {
       Text("View 3")
       .navigationBarBackButtonHidden(true)
       .toolbar(content: {
          ToolbarItem (placement: .navigation)  {
             Image(systemName: "arrow.left")
             .foregroundColor(.white)
             .onTapGesture {
                 // code to dismiss the view
                 self.presentation.wrappedValue.dismiss()
             }
          }
       })
    }
}
