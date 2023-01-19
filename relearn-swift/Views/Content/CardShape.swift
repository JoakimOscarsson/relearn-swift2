//
//  CardShape.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-19.
//

import SwiftUI

struct CardShape: View {
    let cardBackground: Color
    let cardWidth: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardWidth/25)
                .foregroundColor(cardBackground)
            RoundedRectangle(cornerRadius: cardWidth/25)
                .strokeBorder(lineWidth: cardWidth*0.004)
        }
    }
}
