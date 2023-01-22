//
//  mechanicsMenuView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI

struct mechanicsMenuView: View {
    @FetchRequest(fetchRequest: Mechanic.fetchRequests.available)
    private var mechanics: FetchedResults<Mechanic>;
    
    var body: some View {
        List(mechanics, rowContent: mechanicToggleRow.init)
            .navigationTitle("Mechanics")
    }
}

struct mechanicToggleRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var mechanic: Mechanic
    let settings = Settings.shared
    var body: some View {
        Toggle(isOn: $mechanic.enabled) {Text(mechanic.name)}
#warning("Add code in .onChange() to trigger some method in settings to see if we need to change the max pool size!")
    }
}

struct mechanicsMenuView_Previews: PreviewProvider {
    static var previews: some View {
            mechanicsMenuView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
