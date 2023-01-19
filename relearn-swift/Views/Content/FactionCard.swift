//
//  FactionCard.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-16.
//

import SwiftUI


struct FactionCard: View {
    @Environment(\.managedObjectContext) private var viewContext
    let volatileData = VolatileData.shared
    
    var faction: Binding<Faction?>
    @State private var showingSheet = false //TODO: rename to somehting with detials..
    var body: some View {
        ZStack {
            FactionCardFront(faction: faction)
                .opacity((faction.wrappedValue != nil) ? 1: 0)
                .onDisappear(){resetFaction()}
                .onTapGesture{showDetails()}
                .sheet(isPresented: $showingSheet) {
                    FactionDetails(faction: faction.wrappedValue)
                }

            FactionCardBack()
                .opacity((faction.wrappedValue == nil) ? 1: 0)
                .onTapGesture(perform: pickFaction)
        }
    }
    
    func flipCard(){
        pickFaction()
    }
    
    func showDetails() {
        showingSheet.toggle()
    }
    
    func resetFaction(){
        if faction.wrappedValue != nil{
            volatileData.pickedFactions.remove(faction.wrappedValue!)
        }
        faction.wrappedValue = nil
    }
    
    func pickFaction() {
        let factions = try? viewContext.fetch(Faction.fetchRequests.availablePermittedEnabled)
        let filtered = factions?.filter { faction in
            !volatileData.pickedFactions.contains(faction)
        }
        if let newFaction = filtered?.randomElement() {
            volatileData.pickedFactions.insert(newFaction)
            faction.wrappedValue = newFaction
        }
    }
    
    func swipeToReset(dragTranslation: Binding<Double>) -> some View {
        self
            .opacity(1+(dragTranslation.wrappedValue/200))
            .offset(y: dragTranslation.wrappedValue)
            .gesture(DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        dragTranslation.wrappedValue = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -30 {
                        dragTranslation.wrappedValue = -250
                        Task {await delayResetFaction(faction: self.faction, translationValue: dragTranslation)}
                    } else { dragTranslation.wrappedValue = 0 }
                })
            .animation(.default, value: dragTranslation.wrappedValue)
    }
    
    func delayResetFaction(faction: Binding<Faction?>, translationValue: Binding<Double>) async {
        try? await Task.sleep(nanoseconds: 400000000)
        resetFaction()
        try? await Task.sleep(nanoseconds: 5000000)
        translationValue.wrappedValue = 0
    }

}


struct FactionCardPreviewer: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var faction: Faction?
    var body: some View {
        VStack{
            FactionCard(faction: $faction)
        }
    }
}

struct FactionCard_Previews: PreviewProvider {
    static var previews: some View {
        FactionCardPreviewer().ignoresSafeArea(.all)
    }
}



