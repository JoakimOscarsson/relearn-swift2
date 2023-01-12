//
//  DemoView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-09.
//

import SwiftUI
import CoreData


struct setToggleView: View {
    @ObservedObject var gameSet: GameSet
    var body: some View {
        Toggle(isOn: $gameSet.enabled) {
            Text(gameSet.name)
        }.onChange(of: gameSet.enabled){ newValue in gameSet.toggleAvailability(newValue: newValue) }
    }
}

struct factionToggleView: View {
    @ObservedObject var faction: Faction
    var body: some View {
        Toggle(isOn: $faction.enabled) {Text(faction.name)}
    }
}

struct mechanicToggleView: View {
    @ObservedObject var mechanic: Mechanic
    var body: some View {
        Toggle(isOn: $mechanic.enabled) {Text(mechanic.name)}
    }
}

struct setToggleListView: View {
    @FetchRequest(fetchRequest: GameSet.fetchRequestAll()) private var sets: FetchedResults<GameSet>
    
    var body: some View {
        List(sets) { set in
            setToggleView(gameSet: set)
        }
    }
}

struct factionToggleListView: View {
    @FetchRequest(fetchRequest: Faction.allFactionsRequest)
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            factionToggleView(faction: faction)
        }
    }
}



struct mechanicsToggleListView: View {
    @FetchRequest(fetchRequest: Mechanic.allFetchRequest())
    private var mechanics: FetchedResults<Mechanic>
    
    var body: some View {
        List(mechanics) { mechanic in
            mechanicToggleView(mechanic: mechanic)
        }
    }
}

struct factionListView: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            Text(faction.name)
        }
    }
}

struct emptyView: View {
    var body: some View {
        ZStack {
                Color.purple
                    .ignoresSafeArea()
        }
    }
}

struct settingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")){
                    NavigationLink("Available sets", destination: setToggleListView().onDisappear() {
                        try? viewContext.save(); viewContext.refreshAllObjects()
                    })
                    
                    NavigationLink("Permitted mechanics", destination: mechanicsToggleListView().onDisappear() {
                        try? viewContext.save(); viewContext.refreshAllObjects()
                    })
                    
                    NavigationLink("Enabled factions", destination: factionListView().onDisappear() {
                        try? viewContext.save(); viewContext.refreshAllObjects()
                    })
                }
            }
            emptyView()
        }
        
    }
}

//
//        Section(header: Text("Smash Up sets")){
//            NavigationLink("My sets", destination: ownedSetsView(showSettings: $showSettings)
//                            .onDisappear(){try? viewContext.save(); viewContext.refreshAllObjects()})
//        }




struct DemoView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        settingsView()
  
        
        
//        NavigationView {
//            setToggleListView()
//            //factionToggleListView()
//            factionListView()
//        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}




