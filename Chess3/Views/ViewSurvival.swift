//
//  ViewSurvival.swift
//  Chess
//
//  Created by William Becht on 3/30/22.
//

import SwiftUI

struct ViewSurvival: View {
    var body: some View {
        ZStack {
            Color.red
            
            Image(systemName: "exclamationmark.square")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct ViewSurvival_Previews: PreviewProvider {
    static var previews: some View {
        ViewSurvival()
    }
}
