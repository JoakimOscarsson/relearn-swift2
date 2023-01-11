//
//  DemoView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-09.
//

import SwiftUI
import CoreData

//TODO: Move this somewhere or remove it...
func getDateString(date: Date) -> (String) {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

struct DemoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GameSet.date, ascending: true)])
    private var sets: FetchedResults<GameSet>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "gameSet.date", ascending: true), NSSortDescriptor(key: "name_", ascending: true)])
        //predicate: NSPredicate(format: "gameSet.name_ == 'Core Set'"))
    private var factions: FetchedResults<Faction>
    
        
    
    var body: some View {
        List {
            ForEach(factions) { faction in
                Text(faction.name)
            }
//
//            ForEach(sets) { set in
//                Text(set.name + " : " + getDateString(date: set.date!))
//            }
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}





//ViewModels:
extension GameSet {
    var name: String {get{name_!}}
    
    convenience init(in viewContext: NSManagedObjectContext, from s: codableSet) {
        self.init(context: viewContext)
        self.name_ = s.name
        self.info = s.description
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.date(from: s.date)
        s.factions?.forEach(){ f in
            _ = Faction(in: viewContext, from: f, belongingTo: self)
        }
    }
}

extension Faction {
    var name: String {get{name_!}}
    
    convenience init(in viewContext: NSManagedObjectContext, from f: codableFaction, belongingTo gameSet: GameSet) {
        self.init(context: viewContext)
        self.name_ = f.name
        self.info = f.description
        self.image = f.image
        self.gameSet = gameSet
    }
}

