//
//  Persistence.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-08.
//

import CoreData
import SwiftUI




struct PersistenceController {
        
    static let shared = PersistenceController()
    
    static let populate: PersistenceController = {
        let store = PersistenceController()
        let context = store.container.viewContext
        populateStore(in: context)
        
        #warning("Clean up")
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
