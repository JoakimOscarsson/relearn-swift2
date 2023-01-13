//
//  UserData.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-13.
//

import Foundation

enum teamPickingMethod: String, CaseIterable, Identifiable {
    case random
    case pool
    case manual
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

    var poolSize: Int {
        didSet {
            UserDefaults.standard.setValue(poolSize, forKey: "poolSize")
        }
    }

    init() {
        let userDataPlayers = UserDefaults.standard.integer(forKey: "players")
        let userDataPoolSize = UserDefaults.standard.integer(forKey: "poolSize")
        pickMethod = teamPickingMethod(rawValue: UserDefaults.standard.string(forKey: "pickMethod") ?? "random") ?? .random
        players = userDataPlayers != 0 ? userDataPlayers : 2
        poolSize = userDataPoolSize != 0 ? userDataPoolSize : 3
    }
}

//
//struct UserData {
//    init() {
//        
//    }
//    
//    static var players: Int {
//        get {return UserDefaults.standard.integer(forKey: "players")}
//        set {UserDefaults.standard.set(newValue, forKey: "players")}
//    }
//    static var poolSize: Int {
//        get {return UserDefaults.standard.integer(forKey: "poolSize")}
//        set {UserDefaults.standard.set(newValue, forKey: "poolSize")}
//    }
//    static var selectedPickMethod: pickMethod {
//        get {return pickMethod(rawValue: UserDefaults.standard.string(forKey: "pickMethod")!)!}
//        set {UserDefaults.standard.set(newValue.rawValue, forKey: "pickMethod")}
//    }
//    
//}


