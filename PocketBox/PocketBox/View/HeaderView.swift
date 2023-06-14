//
//  HeaderView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Text("PocketBox")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                Spacer()
            }.padding()
            Rectangle()
                .foregroundColor(.yellow)
                .frame(height: 10)
                .opacity(0.3)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
