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
        Toggle(isOn: $gameSet.enabled) {Text(gameSet.name)}; #warning("Why is changes here not reflected?")
    }
}

struct setListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)])
    private var sets: FetchedResults<GameSet>
    
    var body: some View {
        List(sets) { set in
            setToggleView(gameSet: set)
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

struct DemoView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            setListView()
            factionListView()
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}




