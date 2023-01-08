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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
