//
//  FactionCardBack.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-19.
//

import SwiftUI

struct FactionCardBack: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                CardShape(cardBackground: Color.blue, cardWidth: geometry.size.width)

                VStack(spacing: 0){
                    Text("Tap to pick a faction")
                }
            }
        }.aspectRatio(0.714, contentMode:.fit)
        }
}

struct FactionCardBack_Previews: PreviewProvider {
    static var previews: some View {
        FactionCardBack()
    }
}
