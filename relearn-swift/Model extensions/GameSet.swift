//
//  ViewModels.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-11.
//

import Foundation
import CoreData


extension GameSet {
    var name: String {get{name_!}}
        
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
        //Check if set contains modifiers and init them
        if let modifiers = setStruct.modifiers { initModifiers(modifiers, in: viewContext) }
    }
    
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
    
    private func initModifiers(_ modifiers: [codableMechanicModifier], in viewContext: NSManagedObjectContext){
        for codableModifier in modifiers {
            let modifier = Modifier(context: viewContext)
            modifier.set = self
            modifier.mechanic = try! viewContext.fetch(Mechanic.fetchRequestFor(mechanicWithName: codableModifier.mechanicName)).first
            for targetName in codableModifier.targetFactionNames {
                modifier.addToTargets((try? viewContext.fetch(Faction.fetchRequestFor(factionWithName: targetName)).first)!)
            }
        }
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
