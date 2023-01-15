//
//  FetchRequests.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import Foundation
import CoreData

extension GameSet {
    static func fetchRequestAll() -> NSFetchRequest<GameSet> {
        let request = GameSet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)]
        return request
    }
}

extension Faction {
    static func fetchRequestFor(factionWithName faction: String) -> NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", faction)
        request.fetchLimit = 1
        return request
    }
    
    static var enabledFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"),
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count"),
            NSPredicate(format: "enabled == true")])
        request.sortDescriptors = [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
    
    static var allFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}

extension Mechanic {
    static func fetchRequestFor(mechanicWithName mechanic: String) -> NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", mechanic)
        request.fetchLimit = 1
        return request
    }
    
    static func allFetchRequest() -> NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}
