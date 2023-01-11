//
//  StorePopulation.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-11.
//

import Foundation
import CoreData

let mechanicNames = ["Power-Counters", "Monsters", "Treasures", "Madness", "Dueling", "Burying", "Titans"]
let jsonFile = "data.json"

func populateStore(in viewContext: NSManagedObjectContext) {
    clearStore(in: viewContext)
    populateMechanics(in: viewContext)
    populateDataFromJson(in: viewContext)
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

struct codableFaq: Codable {
    let cardname: String
    let question: String
    let answer: String
}

struct codableClarification: Codable {
    let cardname: String
    let clarification: String
}

private func clearStore(in viewContext: NSManagedObjectContext) {
    for entity in (try? viewContext.fetch(GameSet.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Faction.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Mechanic.fetchRequest())) ?? [] {viewContext.delete(entity)}
    for entity in (try? viewContext.fetch(Modifier.fetchRequest())) ?? [] {viewContext.delete(entity)}
    try? viewContext.save()
}

private func populateMechanics(in viewContext: NSManagedObjectContext) {
    for name in mechanicNames {
        let m = Mechanic(context: viewContext)
        m.name_ = name
        m.enabled = true
    }
}

private func populateDataFromJson(in viewContext: NSManagedObjectContext) {
    if let data = readLocalFile(fromFile: jsonFile) {
        let codable_sets = ParseJson(fromJson: data)
        codable_sets?.forEach() { cs in
            let _ = GameSet(in: viewContext, from: cs)
        }
    }
}

private func readLocalFile(fromFile f: String) -> Data?{
    let file = f.split(separator: ".")
    if let filePath = Bundle.main.path(forResource: String(file[0]), ofType: String(file[1])) {
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try? Data(contentsOf: fileUrl)
        return data
    }
    return nil
}

private func ParseJson(fromJson json: Data) -> [codableSet]? {
    do {
        let codables = try JSONDecoder().decode([codableSet].self, from: json)
        return codables
    } catch {
        print("error: \(error)")
    }
    return nil
}
