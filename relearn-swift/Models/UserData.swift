//
//  UserData.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-13.
//

import Foundation

enum teamPickingMethod: String, CaseIterable, Identifiable {
    case manual = "Manually"
    case random = "Randomly"
    case pool = "From a pool"
    var id: Self { self }
}

class Settings: ObservableObject {
    static let shared = Settings()
    
    @Published var pickMethod: teamPickingMethod {
        didSet {
            UserDefaults.standard.setValue(pickMethod.rawValue, forKey: "pickMethod")
        }
    }
    @Published var players: Int {
        didSet {
            UserDefaults.standard.setValue(players, forKey: "players")
        }
    }

    @Published var poolSize: Int {
        didSet {
            UserDefaults.standard.setValue(players, forKey: "poolSize")
        }
    }


    init() {
        let userDataPlayers = UserDefaults.standard.integer(forKey: "players")
        let userDataPoolSize = UserDefaults.standard.integer(forKey: "poolSize")
        pickMethod = teamPickingMethod(rawValue: UserDefaults.standard.string(forKey: "pickMethod") ?? "Manually") ?? .manual
        players = userDataPlayers != 0 ? userDataPlayers : 2
        poolSize = userDataPoolSize != 0 ? userDataPoolSize : 3
    }
}
