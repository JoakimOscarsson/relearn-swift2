//
//  FetchRequests.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import Foundation
import CoreData

extension GameSet {
    static var fetchRequestAll: NSFetchRequest<GameSet> {
        let request = GameSet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)]
        return request
    }
}

extension Faction {
    #warning("Can I do a 'folder' structure where you select a fetch request by 'Faction.FetchRequests.xxxx? Static struct inside of Factions?")
    static func fetchRequestFor(factionWithName faction: String) -> NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", faction)
        request.fetchLimit = 1
        return request
    }
    
    static var possibleFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"),
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count")])
        request.sortDescriptors = defaultSorting
        return request
    }
    
    static var disabledDueToMechanicsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"),
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count != mechanics.@count")])
        request.sortDescriptors = defaultSorting
        return request
    }
    
    static var disabledDueToSetsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSPredicate(format: "gameSet.enabled != true")
        request.sortDescriptors = defaultSorting
        return request
    }
    
    static var enabledFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"),
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count"),
            NSPredicate(format: "enabled == true")])
        request.sortDescriptors = defaultSorting
        return request
    }
    
    static var allFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.sortDescriptors = defaultSorting
        return request
    }
    
    static private var defaultSorting = [
        NSSortDescriptor(key: "gameSet.date", ascending: true),
        NSSortDescriptor(key: "name_", ascending: true)
    ]
}

extension Mechanic {
    static func fetchRequestFor(mechanicWithName mechanic: String) -> NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", mechanic)
        request.fetchLimit = 1
        return request
    }
    
    static var allFetchRequest: NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
    
    
    static var relevantFetchRequest: NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.predicate = NSPredicate(format: "any factions.gameSet.enabled == true")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}
