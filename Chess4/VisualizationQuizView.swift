//
//  VisualizationQuizView.swift
//  Chess4
//
//  Created by William Becht on 6/13/22.
//

import SwiftUI

struct VisualizationQuizView:View {
    @Environment(\.presentationMode) var presentation
    var question = "How many squares does a knight on f6 see?"
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            VStack {
                Text(question)
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
            .toolbar(content: {
               ToolbarItem (placement: .navigation)  {
                  Image(systemName: "arrow.left")
                  .foregroundColor(.white)
                  .onTapGesture {
                      // code to dismiss the view
                      self.presentation.wrappedValue.dismiss()
                  }
               }
                ToolbarItem (placement: .navigationBarTrailing)  {
                    
                    Button {
                        print("settings?")
                    } label: {
                        Image(systemName: "gear")
                        .foregroundColor(.white)
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("logoMaster")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.size.width/2.8, height: UIScreen.main.bounds.size.width/3.0, alignment: .center)
                }
            }
    }
}
