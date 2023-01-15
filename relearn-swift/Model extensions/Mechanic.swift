//
//  Mechanics.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import Foundation
import CoreData

extension Mechanic {
    var name: String {get{name_!}}
    
    convenience init(name: String, in viewContext: NSManagedObjectContext) {
        self.init(context: viewContext)
        self.name_ = name
    }
}
