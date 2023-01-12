//
//  ViewModels.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-11.
//

import Foundation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

//ViewModels:
extension GameSet {
    var name: String {get{name_!}}
    
    func toggleAvailability(newValue: Bool) -> Void {
        (self.modifiers?.allObjects as? [Modifier])?.forEach{ modifier in
            (modifier.targets?.allObjects as? [Faction])?.forEach{ target in
                if newValue {
                    target.addToMechanics(modifier.mechanic!)
                } else {
                    target.removeFromMechanics(modifier.mechanic!)
                }
            }
        }
    }
    
    convenience init(in viewContext: NSManagedObjectContext, from setStruct: codableSet) {
        self.init(context: viewContext)
        self.name_ = setStruct.name
        self.info = setStruct.description
        self.date = dateFormatter.date(from: setStruct.date)
        
        //Go through all factions and init them
        setStruct.factions?.forEach(){ factionStruct in
            let faction = Faction(in: viewContext, from: factionStruct)
            self.addToFactions(faction)
        }
        
        #warning("//TODO: Move modifierinits to separate method")
        if let modifiers = setStruct.modifiers {
            for modifierStruct in modifiers {
                let modifier = Modifier(context: viewContext)
                //Add set to modifier
                modifier.set = self
                //Add mechanic to modifyer
                let mechanic = try! viewContext.fetch(Mechanic.fetchRequestFor(mechanicWithName: modifierStruct.modifier)).first
                modifier.mechanic = mechanic

                #warning("//TODO: This will now load an enabled titans pack without activating the modifiers.")
                //Add targets to modifier
                #warning("//TODO: Make some failsafe which makes sure the targets have been added")
                for target in modifierStruct.modifies {
                    do {
                        let faction = (try viewContext.fetch(Faction.fetchRequestFor(factionWithName: target)).first)!
                        modifier.addToTargets(faction)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    static func fetchRequestAll() -> NSFetchRequest<GameSet> {
        let request = GameSet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)]
        return request
    }
}

extension Mechanic {
    var name: String {get{name_!}}
    
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

extension Faction {
    var name: String {get{name_!}}
    
    convenience init(in viewContext: NSManagedObjectContext, from factionStruct: codableFaction) {
        self.init(context: viewContext)
        self.name_ = factionStruct.name
        self.info = factionStruct.description
        self.image = factionStruct.image
        try? factionStruct.mechanics?.forEach() { mechanicName in
            if let mechanic = try viewContext.fetch(Mechanic.fetchRequestFor(mechanicWithName: mechanicName)).first {
                self.addToMechanics(mechanic)
            }
        }
    }
    
    static func fetchRequestFor(factionWithName faction: String) -> NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", faction)
        request.fetchLimit = 1
        return request
    }
    
    static var enabledFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"), // Set is enabled
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count"), // Mechanic is enabled
            NSPredicate(format: "enabled == true")])  // Faction is enabled
        request.sortDescriptors = [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
    
    static var allFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}

