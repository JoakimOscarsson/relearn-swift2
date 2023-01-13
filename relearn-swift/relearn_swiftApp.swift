//
//  relearn_swiftApp.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-08.
//

import SwiftUI

@main
struct relearn_swiftApp: App {
    //let persistenceController = PersistenceController.shared
    let persistenceController = PersistenceController.populate
//    let userData = UserData() //Init userdata
    var body: some Scene {
        WindowGroup {
            DemoView().environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            /*
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
             */
        }
    }
}
