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
        guard let mechanics = json?.0 else { return }
        guard let sets = json?.1 else { return }
        
        clearStore(in: viewContext)
        populateMechanics(in: viewContext, mechanicNames: mechanics)
        populateData(in: viewContext, codableSets: sets)
    }
}

func populateStoreWithMockData(in viewContext: NSManagedObjectContext) {
    let mockSet = codableSet(name: "Core Set", description: "The Core set", date: "2022-01-01", bases: nil, factions: [
            codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aiens", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Dinosaurs", image: "Dinosaurs", description: "A faction of Dinosaurs", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Pirates", image: "Pirates", description: "A faction of Pirates", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Wizards", image: "Wizards", description: "A faction of Wizards", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Zombies", image: "Zombies", description: "A faction of Zombies", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Tricksters", image: "Tricksters", description: "A faction of Tricksters", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Robots", image: "Robots", description: "A faction of Robots", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
            codableFaction(name: "Ninjas", image: "Ninjas", description: "A faction of Ninjas", overview: nil, bases: nil, mechanics: nil, erratas: nil, clarifications: nil, faq: nil),
    ], modifiers: nil)
    let _ = GameSet(in: viewContext, from: mockSet)
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

func populateMechanics(in viewContext: NSManagedObjectContext, mechanicNames: [String]) {
    for name in mechanicNames {
        let m = Mechanic(context: viewContext)
        m.name_ = name
        m.enabled = true
    }
}

func populateData(in viewContext: NSManagedObjectContext, codableSets: [codableSet]) {
    codableSets.forEach() { cs in
        let _ = GameSet(in: viewContext, from: cs)
    }
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

struct codableClarification: Codable {
    let cardname: String
    let clarification: String
}

struct codableFaq: Codable {
    let cardname: String
    let question: String
    let answer: String
}
