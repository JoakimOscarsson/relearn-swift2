//
//  TeamAndFactionViews.swift
//  smash up team randomizer
//
//  Created by Joakim Oscarsson on 2021-07-18.
//  Copyright © 2021 Joakim Oscarsson. All rights reserved.
//

import SwiftUI

struct FactionView: View {
    let faction: Faction?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:UIConstants.factionCornerRadius).foregroundColor(CustomColors.factionCardBackground)
            RoundedRectangle(cornerRadius:UIConstants.factionCornerRadius).strokeBorder(lineWidth: UIConstants.factionBorderWidth)
            VStack {
                Spacer()
                Text(faction != nil ? faction!.name : "Missing Faction")
                    .fontWeight(.heavy)
                    .padding([.top, .leading, .trailing])
                #warning("clean up below:")
                GeometryReader {geometry in
//                    (faction != nil ? Image(faction!.image) : Image(systemName: "square.dashed"))
                    (faction != nil ? (faction!.image != nil ? Image(faction!.image!) : Image(systemName: "square.dashed")) : Image(systemName: "square.dashed"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: scaleFrame(geometry.size.width),
                               height: scaleFrame(geometry.size.height))
                        .offset(x: offsetFrame(geometry.size.width),
                                y: offsetFrame(geometry.size.height))
                        
                }.padding(.bottom)
            }
        }
    }
    var scaleFrame: (CGFloat) -> CGFloat = {d in d*UIConstants.imageScaler}
    var offsetFrame: (CGFloat) -> CGFloat = {d in d*(1-UIConstants.imageScaler)/2}
}

struct Team: Identifiable {
    var id: String
    var faction1: Faction?
    var faction2: Faction?
}

struct TeamView: View {
    let team: Team
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius:UIConstants.teamCornerRadius)
                .foregroundColor(CustomColors.teamBoxBackground)
            RoundedRectangle(cornerRadius:UIConstants.teamCornerRadius)
                .strokeBorder(lineWidth: UIConstants.teamBorderWidth)
            VStack(alignment: .center, spacing: UIConstants.teamVSpacing) {
                Text(team.id).font(.largeTitle)
                    .foregroundColor(CustomColors.teamBoxFont)
                    .padding([.top, .leading, .trailing])
                HStack {
                    FactionView(faction: team.faction1)
                        .aspectRatio(UIConstants.cardAspectRatio, contentMode: .fit)
                        .padding([.top, .leading, .bottom])
                    FactionView(faction: team.faction2)
                        .aspectRatio(UIConstants.cardAspectRatio, contentMode: .fit)
                        .padding([.top, .bottom, .trailing])
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
    }
}


//struct TeamAndFactionViews_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamAndFactionViews()
//    }
//}
