//
//  teamView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-16.
//

import SwiftUI

struct teamView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var team: Team
    @State private var dragTranslation1 = 0.0
    @State private var dragTranslation2 = 0.0
    
    let volatileData = VolatileData.shared
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                RoundedRectangle(cornerRadius: geometry.size.width/35)
                    .foregroundColor(CustomColors.teamBoxBackground)
                RoundedRectangle(cornerRadius: geometry.size.width/35)
                    .strokeBorder(lineWidth: geometry.size.width*0.004)
                
                VStack {
                    Text(team.id)
                        .font(.custom("playerFont", size: geometry.size.width*0.12))
                    HStack(spacing: geometry.size.width*0.02) {
                        FactionCard(faction: $team.faction1)
                            .swipeToReset(dragTranslation: $dragTranslation1)
                            .padding(.leading, geometry.size.width*0.035)
                        
                        FactionCard(faction: $team.faction2)
                            .swipeToReset(dragTranslation: $dragTranslation2)
                            .padding(.trailing, geometry.size.width*0.035)
                    }
                }
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}
    

struct Team: Identifiable {
    var id: String
    var faction1: Faction?
    var faction2: Faction?
}


struct teamViewPreviewer: View {
    @Environment(\.managedObjectContext) private var viewContext
    let rawFaction = codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aliens")
    var body: some View {
        let team = Team(id: "Player X",
                        faction1: Faction(in: viewContext, from: rawFaction),
                        faction2: Faction(in: viewContext, from: rawFaction))
        
        VStack {
            teamView(team: team)
        }
    }
}

struct teamView_Previews: PreviewProvider {
    static var previews: some View {
        teamViewPreviewer()
    }
}
