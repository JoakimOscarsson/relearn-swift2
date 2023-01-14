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
        }.navigationTitle("Sets")
    }
}

struct factionToggleListView: View {
    @FetchRequest(fetchRequest: Faction.allFactionsRequest)
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            factionToggleView(faction: faction)
        }.navigationTitle("Factions")
    }
}

struct mechanicsToggleListView: View {
    @FetchRequest(fetchRequest: Mechanic.allFetchRequest())
    private var mechanics: FetchedResults<Mechanic>
    
    var body: some View {
        List(mechanics) { mechanic in
            mechanicToggleView(mechanic: mechanic)
        }.navigationTitle("Mechanics")
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
            EmptyView()
        }
        
    }
}

//
//        Section(header: Text("Smash Up sets")){
//            NavigationLink("My sets", destination: ownedSetsView(showSettings: $showSettings)
//                            .onDisappear(){try? viewContext.save(); viewContext.refreshAllObjects()})
//        }

struct navView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationSplitView {
            List{
                NavigationLink("Available sets", destination: setToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })

                NavigationLink("Permitted mechanics", destination: mechanicsToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })

                NavigationLink("Enabled factions", destination: factionToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })
            }
        } detail: {
            factionListView()
        }
    }
}

struct numOfPlayersView: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
        HStack{
            Stepper("Number of Players: \(settings.players)",
                    value: $settings.players,
                    in: 2...4)
        }
    }
}

struct poolSizeView: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    @ObservedObject var settings = Settings.shared
    var body: some View {
        Stepper("Pool Size: \(settings.poolSize)",
                value: $settings.poolSize,
                in: 3...factions.count)
    }
}

struct pickMethodView: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
            Picker("Pick teams", selection: $settings.pickMethod) {
                ForEach(teamPickingMethod.allCases) { method in
                    Text(method.rawValue)
                }
            }
    }
}

struct customView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings = Settings.shared
    var body: some View {
        GeometryReader { geometry in
        
            HStack(
                spacing: 0.5
            ){
                NavigationStack {
                    Form{
                        
                        Section("Players"){
                            List{
                                numOfPlayersView()
                            }
                        }
                        Section("Team selection"){
                            List{
                                pickMethodView()
                                poolSizeView()
                                    .disabled(settings.pickMethod != .pool)
                                    .foregroundColor({return settings.pickMethod != .pool ? .gray : .black}())
                            }
                        }
                        Section("Factions filtering"){
                            NavigationLink("Available sets", destination: setToggleListView().onDisappear() {
                                try? viewContext.save(); viewContext.refreshAllObjects()
                            })
                            
                            NavigationLink("Permitted mechanics", destination: mechanicsToggleListView().onDisappear() {
                                try? viewContext.save(); viewContext.refreshAllObjects()
                            })
                            
                            NavigationLink("Enabled factions", destination: factionToggleListView().onDisappear() {
                                try? viewContext.save(); viewContext.refreshAllObjects()
                            })
                        }
                    }
                    .navigationTitle("Options")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: closeNav) {
                                Label("Close", systemImage: "xmark")
                            }
                        }
                    }
                }.frame(width: geometry.size.width * 0.27)
                factionListView()
            }
        }.background(Color(.lightGray))
    }
    private func closeNav(){
        
    }
}


struct DemoView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        
        customView()
        
//        navView()
        
        
//        settingsView()
  
        
        
//        NavigationView {
//            setToggleListView()
//            //factionToggleListView()
//            factionListView()
//        }
    }
}




