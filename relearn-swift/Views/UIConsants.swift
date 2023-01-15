//
//  UIConstants.swift
//  smash up team randomizer
//
//  Created by Joakim Oscarsson on 2021-07-19.
//  Copyright © 2021 Joakim Oscarsson. All rights reserved.
//

import SwiftUI

#warning("clean up here.. some of these are probably not used!")
struct UIConstants {
    //MARK: Faction constats
    static let factionCornerRadius: CGFloat = 15
    static let factionBorderWidth: CGFloat = 1
    static let cardAspectRatio: CGFloat = 5/7
    static let imageScaler: CGFloat = 0.8
    //MARK: Team constants
    static let teamBoxMaxWidth: CGFloat = 355
    static let teamCornerRadius: CGFloat = 25
    static let teamBorderWidth: CGFloat = 2
    static let teamVSpacing: CGFloat = 0
    //MARK: Buttons constants
    static let fontType: Font = Font.title2
    static let buttonCornerRadius: CGFloat = 5
    static let buttonBorder: CGFloat = 2
}

struct CustomColors {
    static let appBackground = Color(
        red: 240.0/255.0,
        green: 248.0/255.0,
        blue: 255.0/255.0
    ) ; #warning("No darkmode color defined")
    static let teamBoxBackground = Color(
            red: 47.0/255.0,
            green: 79.0/255.0,
            blue: 79.0/255.0
    )
    static let factionCardBackground = Color(
        red: 211.0/255.0,
        green: 211.0/255.0,
        blue: 211.0/255.0
    )
    static let teamBoxFont = Color(
        red: 255.0/255.0,
        green: 165.0/255.0,
        blue: 0.0/255.0
    )
}
