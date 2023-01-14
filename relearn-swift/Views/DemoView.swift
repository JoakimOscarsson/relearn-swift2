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
#warning("Make some generic view for the toggle list views")
struct factionListView: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            Text(faction.name)
        }
    }
}

struct numOfPlayersView: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
        HStack{
            Stepper("Number of Players: \(settings.players)",
                    value: $settings.players,
                    in: 2...4) ; #warning("implement check to see if there are enought factions for specief number of players")
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
                in: 3...factions.count) ; #warning("Implement change here if num of factions changes!")
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
