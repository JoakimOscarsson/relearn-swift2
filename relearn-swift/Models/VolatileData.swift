//
//  VolatileData.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-17.
//

import Foundation

class VolatileData {
    static let shared = VolatileData()
    
    var pickedFactions = Set<Faction>()
}
