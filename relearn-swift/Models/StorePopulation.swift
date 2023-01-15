//
//  StorePopulation.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-11.
//

import Foundation
import CoreData


let jsonFile = "data.json"

func populateStore(in viewContext: NSManagedObjectContext) {
    if let data = readLocalFile(fromFile: jsonFile) {
        let json = parseJson(fromJson: data)
        let mechanicNames = json!.0
        let codableSets = json!.1
        
        clearStore(in: viewContext)
        for name in mechanicNames {
            let _ = Mechanic(name: name, in: viewContext)
        }
        codableSets.forEach() { cs in
            let gameSet = GameSet(in: viewContext, from: cs)
            if gameSet.name == "Core Set" {gameSet.enabled = true}
        }
    }
}

func populatePreview(in viewContext: NSManagedObjectContext) {
    let mockSet = codableSet(name: "Core Set", description: "The Core set", date: "2022-01-01", factions: [
            codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aiens"),
            codableFaction(name: "Dinosaurs", image: "Dinosaurs", description: "A faction of Dinosaurs"),
            codableFaction(name: "Pirates", image: "Pirates", description: "A faction of Pirates"),
            codableFaction(name: "Wizards", image: "Wizards", description: "A faction of Wizards"),
            codableFaction(name: "Zombies", image: "Zombies", description: "A faction of Zombies"),
            codableFaction(name: "Tricksters", image: "Tricksters", description: "A faction of Tricksters"),
            codableFaction(name: "Robots", image: "Robots", description: "A faction of Robots"),
            codableFaction(name: "Ninjas", image: "Ninjas", description: "A faction of Ninjas"),
    ])
    let gameSet = GameSet(in: viewContext, from: mockSet)
    gameSet.enabled = true
    
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

func parseJson(fromJson json: Data) -> ([String], [codableSet])? {
    do {
        let json = try JSONDecoder().decode(jsonData.self, from: json)
        return (json.mechanics, json.sets)
    } catch {
        print("error: \(error)")
    }
    return nil
}

func clearStore(in viewContext: NSManagedObjectContext) {
    for entity in (try? viewContext.fetch(GameSet.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Faction.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Mechanic.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Modifier.fetchRequest())) ?? [] {viewContext.delete(entity)}
    try? viewContext.save()
}

struct jsonData: Codable {
    let mechanics: [String]
    let sets: [codableSet]
}

struct codableSet: Codable {
    let name: String
    let description: String
    let date: String
    let bases: String?
    let factions: [codableFaction]?
    let modifiers: [codableMechanicModifier]?
    
    init(name: String,
         description : String,
         date: String,
         bases: String? = nil,
         factions: [codableFaction]? = nil,
         modifiers: [codableMechanicModifier]? = nil) {
        self.name = name
        self.description = description
        self.date = date
        self.bases = bases
        self.factions = factions
        self.modifiers = modifiers
    }
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
    
    init(name: String,
         image: String,
         description: String,
         overview: String? = nil,
         bases: String? = nil,
         mechanics: [String]? = nil,
         erratas: [codableErrata]? = nil,
         clarifications: [codableClarification]? = nil,
         faq: [codableFaq]? = nil) {
        self.name = name
        self.image = image
        self.description = description
        self.overview = overview
        self.bases = bases
        self.mechanics = mechanics
        self.erratas = erratas
        self.clarifications = clarifications
        self.faq = faq
    }
}

struct codableMechanicModifier: Codable {
    let mechanicName: String
    let targetFactionNames: [String]
}

struct codableErrata: Codable {
    let cardname: String
    let errata: String
}

struct codableClarification: Codable {
    let cardname: String
    let clarification: String
}

struct codableFaq: Codable {
    let cardname: String
    let question: String
    let answer: String
}
