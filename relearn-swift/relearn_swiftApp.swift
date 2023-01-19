//
//  relearn_swiftApp.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-08.
//

import SwiftUI

@main
struct relearn_swiftApp: App {
    let persistenceController = PersistenceController.shared
    //let persistenceController = PersistenceController.populate
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
