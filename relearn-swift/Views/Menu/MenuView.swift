//
//  MenuView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI

struct MenuContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings = Settings.shared
    @Binding var menuOpen: Bool

    var body: some View {
        Form{
            Section("Players"){
                List{
                    numOfPlayersView()
                }
            }
            Section("Team selection"){
                List{
                    pickMethodView()
                    poolSizeView()
                        .disabled(settings.pickMethod != .pool)
                        .foregroundColor({return settings.pickMethod != .pool ? .gray : .black}())
                }
            }
            Section("Factions filtering"){
                NavigationLink("Available sets", destination: setToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })

                NavigationLink("Permitted mechanics", destination: mechanicsToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })

                NavigationLink("Enabled factions", destination: factionToggleListView().onDisappear() {
                    try? viewContext.save(); viewContext.refreshAllObjects()
                })
            }
        }
        .navigationTitle("Options")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {menuOpen.toggle()}) {Image(systemName: "sidebar.left")}
            }
        }
    }
}

struct MenuView: View {
    @State private var offset: CGFloat = .zero
    @Binding var menuOpen: Bool
    let width: CGFloat
    
    var body: some View {
        ZStack{
            //Background dimmer
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.25))
            .opacity(self.menuOpen ? 1 : 0)
            .animation(.easeIn(duration: 0.15), value: menuOpen)
            
            // Menu
            HStack{
                NavigationStack{
                    MenuContentView(menuOpen: $menuOpen)
                }
                    .frame(width: width)
                    .offset(x: menuOpen ? 0 : -width)
                    .animation(.easeIn(duration: 0.15), value: menuOpen)
                Spacer()
            }
            .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {menuOpen.toggle()}
                })
        }
    }
}


#warning("Make some generic view for toggleviews")
struct setToggleView: View {
    @ObservedObject var gameSet: GameSet
    var body: some View {
        Toggle(isOn: $gameSet.enabled) {
            Text(gameSet.name)
        }.onChange(of: gameSet.enabled){ newValue in gameSet.toggleAvailability(newValue: newValue) }
    }
}

struct factionToggleView: View {
    @ObservedObject var faction: Faction
    var body: some View {
        Toggle(isOn: $faction.enabled) {Text(faction.name)}
    }
}

struct mechanicToggleView: View {
    @ObservedObject var mechanic: Mechanic
    var body: some View {
        Toggle(isOn: $mechanic.enabled) {Text(mechanic.name)}
    }
}

struct setToggleListView: View {
    @FetchRequest(fetchRequest: GameSet.fetchRequestAll()) private var sets: FetchedResults<GameSet>
    
    var body: some View {
        List(sets) { set in
            setToggleView(gameSet: set)
        }.navigationTitle("Sets")
    }
}

struct factionToggleListView: View {
    @FetchRequest(fetchRequest: Faction.allFactionsRequest) //TODO: Intorduce separate list of disabled factions due to various reasons
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            factionToggleView(faction: faction)
        }.navigationTitle("Factions")
    }
}

struct mechanicsToggleListView: View {
    @FetchRequest(fetchRequest: Mechanic.allFetchRequest())
    private var mechanics: FetchedResults<Mechanic>;  #warning("why is this different from the Faction request? () vs nont using ()")
    
    var body: some View {
        List(mechanics) { mechanic in
            mechanicToggleView(mechanic: mechanic)
        }.navigationTitle("Mechanics")
    }
}
#warning("Make some generic view for the toggle list views")
struct factionListView: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    
    var body: some View {
        List(factions) { faction in
            Text(faction.name)
        }
    }
}

struct numOfPlayersView: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
        HStack{
            Stepper("Number of Players: \(settings.players)",
                    value: $settings.players,
                    in: 2...4) ; #warning("implement check to see if there are enought factions for specief number of players")
        }
    }
}

struct poolSizeView: View {
    @FetchRequest(fetchRequest: Faction.enabledFactionsRequest)
    private var factions: FetchedResults<Faction>
    @ObservedObject var settings = Settings.shared
    var body: some View {
        Stepper("Pool Size: \(settings.poolSize)",
                value: $settings.poolSize,
                in: minValue...factions.count)
#warning("Implement change here if num of factions changes!")
    }
    
    private var minValue: Int {
        return (factions.count >= 3 ? 3 : 0)
    }
}

struct pickMethodView: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
            Picker("Pick teams", selection: $settings.pickMethod) {
                ForEach(teamPickingMethod.allCases) { method in
                    Text(method.rawValue)
                }
            }
    }
}

struct MenuViewPreviewer: View {
    @State private var constant = true
    var body: some View {
        MenuContentView(menuOpen: $constant)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MenuViewPreviewer().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
