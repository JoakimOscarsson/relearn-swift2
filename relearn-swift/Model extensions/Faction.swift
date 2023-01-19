//
//  Faction.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import Foundation
import CoreData

extension Faction {
    var name: String {get{name_!}}
    
    convenience init(in viewContext: NSManagedObjectContext, from factionStruct: codableFaction) {
        self.init(context: viewContext)
        self.name_ = factionStruct.name
        self.info = factionStruct.description
        self.image = factionStruct.image
        try? factionStruct.mechanics?.forEach() { mechanicName in
            if let mechanic = try viewContext.fetch(Mechanic.fetchRequests.withName(name: mechanicName)).first {
                self.addToMechanics(mechanic)
            }
        }
    }
}
