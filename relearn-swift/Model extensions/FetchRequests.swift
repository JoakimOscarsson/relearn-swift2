//
//  FetchRequests.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import Foundation
import CoreData

extension GameSet {
    struct fetchRequests {
        static var all: NSFetchRequest<GameSet> {
            let request = GameSet.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)]
            return request
        }
    }
}

extension Faction {
    struct fetchRequests {
        static var all: NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.sortDescriptors = defaultSorting
            return request
        }
        static func withName(name faction: String) -> NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.predicate = NSPredicate(format: "name_ LIKE %@", faction)
            request.fetchLimit = 1
            return request
        }
        static var availablePermitted: NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
                NSPredicate(format: "gameSet.enabled == true"),
                NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count")])
            request.sortDescriptors = defaultSorting
            return request
        }
        static var availableNotPermitted: NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
                NSPredicate(format: "gameSet.enabled == true"),
                NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count != mechanics.@count")])
            request.sortDescriptors = defaultSorting
            return request
        }
        static var notAvailable: NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.predicate = NSPredicate(format: "gameSet.enabled != true")
            request.sortDescriptors = defaultSorting
            return request
        }
        static var availablePermittedEnabled: NSFetchRequest<Faction> {
            let request = Faction.fetchRequest()
            request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
                NSPredicate(format: "gameSet.enabled == true"),
                NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count"),
                NSPredicate(format: "enabled == true")])
            request.sortDescriptors = defaultSorting
            return request
        }
        static private var defaultSorting = [
            NSSortDescriptor(key: "gameSet.date", ascending: true),
            NSSortDescriptor(key: "name_", ascending: true)
        ]
    }
}

extension Mechanic {
    struct fetchRequests {
        static var all: NSFetchRequest<Mechanic> {
            let request = Mechanic.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
            return request
        }
        static var available: NSFetchRequest<Mechanic> {
            let request = Mechanic.fetchRequest()
            request.predicate = NSPredicate(format: "any factions.gameSet.enabled == true")
            request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
            return request
        }
        static func withName(name mechanic: String) -> NSFetchRequest<Mechanic> {
            let request = Mechanic.fetchRequest()
            request.predicate = NSPredicate(format: "name_ LIKE %@", mechanic)
            request.fetchLimit = 1
            return request
        }
    }
}
