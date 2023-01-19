//
//  setMenuView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI

struct setMenuView: View {
    @FetchRequest(fetchRequest: GameSet.fetchRequests.all) private var sets: FetchedResults<GameSet>
    
    var body: some View {
        List(sets, rowContent: setToggleRow.init)
            .navigationTitle("Sets")
    }
}

#warning("Make some generic view for toggleviews")
struct setToggleRow: View {
    @ObservedObject var gameSet: GameSet
    var body: some View {
        Toggle(isOn: $gameSet.enabled) {Text(gameSet.name)}
            .onChange(of: gameSet.enabled){ newValue in gameSet.toggleAvailability(newValue: newValue) }
            #warning("Add code to trigger some method in settings to see if we need to change the max pool size!")
    }
}

struct setMenuView_Previews: PreviewProvider {
    static var previews: some View {
        setMenuView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
