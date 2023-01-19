//
//  FactionDetails.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-19.
//

import SwiftUI

struct FactionDetails: View {
    var faction: Faction?

    var body: some View {
        VStack{
            Text(faction?.name ?? "no faction found").font(.largeTitle).padding(.top)
            Spacer()
            Text(faction?.info ?? "").padding(.horizontal)
            Spacer()
        }
    }
}


struct FactionDetailsPreviewer: View {
    @Environment(\.managedObjectContext) private var viewContext
    let rawFaction = codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aliens")
    var body: some View {
        FactionDetails(faction: Faction(in: viewContext, from: rawFaction))
    }
}

struct FactionDetails_Previews: PreviewProvider {
    static var previews: some View {
        FactionDetailsPreviewer()
    }
}
