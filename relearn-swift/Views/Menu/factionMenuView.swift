//
//  factionMenuView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI

struct factionMenuView: View {
    @FetchRequest(fetchRequest: Faction.fetchRequests.availablePermitted)
    private var factions: FetchedResults<Faction>
    
    @FetchRequest(fetchRequest: Faction.fetchRequests.availableNotPermitted)
    private var noMechFactions: FetchedResults<Faction>
    
    @FetchRequest(fetchRequest: Faction.fetchRequests.notAvailable)
    private var noSetFactions: FetchedResults<Faction>
    
    var body: some View {
        #warning("Look into making a viewbuilder to get conditional sections?")
        Form {
            Section(content: {
                List(factions, rowContent: factionToggleRow.init)
            }, header: {
                Text("Toggle to disable")
            }, footer: {
                Text("Disabled factions can not be selected when picking teams.")
            }).navigationTitle("Factions")
            
            Section(content: {
                List(noMechFactions, rowContent: factionNoToggleRow.init)
            }, header: {
                Text("Forbidden by Mechancis") //Alt: Forbidden by mechanics
            }, footer: {
                Text("You can permit mechanics in the mechanics menu.")
            }).navigationTitle("Factions")
            
            Section(content: {
                List(noSetFactions, rowContent: factionNoToggleRow.init)
            }, header: {
                Text("In Unavailable Sets")
            }, footer: {
                Text("You can specify set availability in the sets menu.")
            }).navigationTitle("Factions")
        }
    }
}

struct factionNoToggleRow: View {
    var faction: Faction
    @State private var toggle = false
    var body: some View {
        Toggle(isOn: $toggle) {Text(faction.name)}
            .disabled(true)
            .foregroundColor(.gray)
    }
}

struct factionToggleRow: View {
    @ObservedObject var faction: Faction
    var body: some View {
        Toggle(isOn: $faction.enabled) {Text(faction.name)}
        #warning("Add code in .onChange() to trigger some method in settings to see if we need to change the max pool size!")
    }
}


struct factionMenuView_Previews: PreviewProvider {
    static var previews: some View {
        factionMenuView()
    }
}
