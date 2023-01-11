//
//  DemoView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-09.
//

import SwiftUI
import CoreData

//TODO: Move this somewhere or remove it...
func getDateString(date: Date) -> (String) {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

struct DemoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)])
    private var sets: FetchedResults<GameSet>
    
    
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)])
//        //predicate: NSPredicate(format: "gameSet.name_ == 'Core Set'"))
//    private var factions: FetchedResults<Faction>
    
        
    
    var body: some View {
        List {
            ForEach(factions) { faction in
                Text(faction.name)
            }
//
//            ForEach(sets) { set in
//                Text(set.name + " : " + getDateString(date: set.date!))
//            }
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}





//ViewModels:
extension GameSet {
    var name: String {get{name_!}}
    
    convenience init(in viewContext: NSManagedObjectContext, from setStruct: codableSet) {
        self.init(context: viewContext)
        self.name_ = setStruct.name
        self.info = setStruct.description
        
        let formatter = DateFormatter() //TODO: Should not be in init?
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.date(from: setStruct.date)
        setStruct.factions?.forEach(){ factionStruct in
            let faction = Faction(in: viewContext, from: factionStruct)
            self.addToFactions(faction)
        }
        
        //TODO: Move modifierinits to separate method
        if let modifiers = setStruct.modifiers {
            for modifierStruct in modifiers {
                let modifier = Modifier(context: viewContext)
                //Add set to modifier
                modifier.set = self
                
                //Add mechanic to modifyer
                let mechanic = try! viewContext.fetch(Mechanic.fetchRequestFor(mechanicWithName: modifierStruct.modifier)).first
                modifier.mechanic = mechanic

                //TODO: This will now load an enabled titans pack without activating the modifiers.
                //Add targets to modifier //TODO: Make some failsafe which makes sure the targets have been added
                let factionRequest = Faction.fetchRequest() //TODO: Change to static method in Faction (see mechanics)
                factionRequest.fetchLimit = 1
                for target in modifierStruct.modifies {
                    factionRequest.predicate = NSPredicate(format: "name_ LIKE %@", target)
                    do {
                        let faction = (try viewContext.fetch(factionRequest).first)! //NOTE: No duplicate support
                        modifier.addToTargets(faction)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

extension Mechanic {
    static func fetchRequestFor(mechanicWithName mechanic: String) -> NSFetchRequest<Mechanic> {
        let request = Mechanic.fetchRequest()
        request.predicate = NSPredicate(format: "name_ LIKE %@", mechanic)
        request.fetchLimit = 1
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
    
    static var enabledFactionsRequest: NSFetchRequest<Faction> {
        let request = Faction.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[
            NSPredicate(format: "gameSet.enabled == true"), // Set is enabled
            NSPredicate(format: "SUBQUERY(mechanics, $mech, $mech.enabled == true).@count == mechanics.@count"), // Mechanic is enabled
            NSPredicate(format: "enabled == true")])  // Faction is enabled
        request.sortDescriptors = [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}

