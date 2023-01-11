//
//  Persistence.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-08.
//

import CoreData
import SwiftUI


struct codableSet: Codable {
    let name: String
    let description: String
    let date: String
    let bases: String?
    let factions: [codableFaction]?
    let modifiers: [codableModifierSpec]?
}

struct codableFaction: Codable {
    let name: String
    let image: String
    let description: String?
    let overview: String?
    let bases: String?
    let mechanics: [String]?
    let erratas: [codableErrata]?
    let clarifications: [codableClarification]?
    let faq: [codableFaq]?
}

struct codableModifierSpec: Codable {
    let modifier: String
    let modifies: [String]
}

struct codableErrata: Codable {
    let cardname: String
    let errata: String
}

struct codableFaq: Codable {
    let cardname: String
    let question: String
    let answer: String
}

struct codableClarification: Codable {
    let cardname: String
    let clarification: String
}


func readLocalFile(fromFile f: String) -> Data?{
    let file = f.split(separator: ".")
    if let filePath = Bundle.main.path(forResource: String(file[0]), ofType: String(file[1])) {
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try? Data(contentsOf: fileUrl)
        return data
    }
    return nil
}

func ParseJson(fromJson json: Data) -> [codableSet]? {
    do {
        let codables = try JSONDecoder().decode([codableSet].self, from: json)
        return codables
    } catch {
        print("error: \(error)")
    }
    return nil
}

struct PersistenceController {
        
    static let shared = PersistenceController()
    
    static let populate: PersistenceController = {
        
        let store = PersistenceController()
        let context = store.container.viewContext
        
        
        // TODO: Make a separate cleanup function
        //Remove all 'Item's and GameSets:
        for entity in (try? context.fetch(GameSet.fetchRequest())) ?? [] {context.delete(entity)}
        for entity in (try? context.fetch(Faction.fetchRequest())) ?? [] {context.delete(entity)}
        for entity in (try? context.fetch(Mechanic.fetchRequest())) ?? [] {context.delete(entity)}
        for entity in (try? context.fetch(Modifier.fetchRequest())) ?? [] {context.delete(entity)}
        try? context.save()
        
        
        //TODO: Make separate function for populating Mechanics
        let mechanicNames = ["Power-Counters", "Monsters", "Treasures", "Madness", "Dueling", "Burying", "Titans"]
        for name in mechanicNames {
            let m = Mechanic(context: context)
            m.name_ = name
            m.enabled = true
        }
        
        //TODO: Make a separate function for populating the data
        //Load data from file, Parse Json and create sets (and included factions)
        if let data = readLocalFile(fromFile: "data.json") {
            let codable_sets = ParseJson(fromJson: data)
            codable_sets?.forEach() { cs in
                let _ = GameSet(in: context, from: cs)
            }
        }

        
//        //Do a demo and disable singel faction: Check!!.
//        if let faction = try? context.fetch(Faction.fetchRequest()).first {
//            print("Disabled faction is: \(faction.name)")
//            faction.enabled = false
//        }
        
//        //Do a demo and disable a set: Check!!.
//        if let gameSet = try? context.fetch(GameSet.fetchRequest()).first {
//            print("Disabled set is: \(gameSet.name)")
//            gameSet.enabled = false
//        }
        
//        //Do a demo and disable a mechanic: Check!!
//        if let mechanic = try? context.fetch(Mechanic.fetchRequest()).first {
//            print("Disabled mechanic is: \(mechanic.name_ ?? "Error: Mechanic is missing!")")
//            mechanic.enabled = false
//        }
        
        
        try? context.save()
        
        
        /*
        do {
            let fetchedItems = try store.container.viewContext.fetch(itemFetch)
            print("num of items: \(fetchedItems.count)")
            
            fetchedItems.forEach(store.container.viewContext.delete)
            
            try store.container.viewContext.save()
            print("num of items: \(fetchedItems.count)")
        } catch let e as NSError {
            print(e.description)
        }
         */
        
        return store
    }()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "relearn_swift")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
