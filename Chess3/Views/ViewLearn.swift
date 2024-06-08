//
//  ViewLearn.swift
//  Chess
//
//  Created by William Becht on 3/30/22.
//

import SwiftUI

struct ViewLearn: View {
    var body: some View {
        ZStack {
            Color.green
            
            Image(systemName: "studentdesk")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct ViewLearn_Previews: PreviewProvider {
    static var previews: some View {
        ViewLearn()
    }
}
