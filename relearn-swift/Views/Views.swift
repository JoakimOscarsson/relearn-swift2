//
//  Views.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-14.
//

import SwiftUI

struct Views: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest) private var factions: FetchedResults<Faction>
    var body: some View {
        List{
            ForEach(factions){ faction in
                Text(faction.name)
            }
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}







//struct Views_Previews: PreviewProvider {
//    static var previews: some View {
//        Views().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
