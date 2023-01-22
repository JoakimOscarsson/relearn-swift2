//
//  MenuView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI
import CoreData

extension View {
    func saveOnDisappear(context: NSManagedObjectContext) -> some View {
        self.onDisappear(){
            try? context.save()
            context.refreshAllObjects()
        }
    }
}

struct MenuContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings = Settings.shared
    @Binding var menuOpen: Bool

    var body: some View {
        Form{
            Section("Players"){
                List{numOfPlayersRow()}
            }
            Section("Team selection"){
                List{
                    pickMethodRow()
                    poolSizeRow()
                        .enableOnPool()
                }
            }
            Section("Factions filtering"){
                NavigationLink("Available sets", destination: setMenuView().saveOnDisappear(context: viewContext))
                NavigationLink("Permitted mechanics", destination: mechanicsMenuView().saveOnDisappear(context: viewContext))
                NavigationLink("Enabled factions", destination: factionMenuView().saveOnDisappear(context: viewContext))
            }
        }
        .navigationTitle("Options")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {menuOpen.toggle()}) {Image(systemName: "sidebar.left")}
            }
        }
    }
    func poolSizeDisabled() -> Bool {
        return settings.pickMethod != .pool
    }
    func poolSizeColor() -> Color {
        return settings.pickMethod != .pool ? .gray : .black
    }
}
struct LargeMenuView: View {
    @Binding var menuOpen: Bool
    var body: some View {
        if menuOpen{
            NavigationStack {
                MenuContentView(menuOpen: $menuOpen)
            }
        }
    }
}

struct SideBarMenuView: View {
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
#warning("This warning should be elsewhere. The details view for factions is not closable on small screens!")
struct MenuView: View {
    @Binding var menuOpen: Bool
    var body: some View {
        GeometryReader(){ geometry in
            if geometry.size.width < 700 {
                LargeMenuView(menuOpen: $menuOpen)
            } else {
                SideBarMenuView(menuOpen: $menuOpen, width: 400)
            }
        }
    }
}

struct numOfPlayersRow: View {
    @ObservedObject var settings = Settings.shared
    var body: some View {
        HStack{
            Stepper("Number of Players: \(settings.players)",
                    value: $settings.players,
                    in: 2...4)
        }
    }
}

struct poolSizeRow: View {
    @FetchRequest(fetchRequest: Faction.fetchRequests.availablePermittedEnabled)
    private var factions: FetchedResults<Faction>
    @ObservedObject var settings = Settings.shared
    var body: some View {
        Stepper("Pool Size: \(settings.poolSize)",
                value: $settings.poolSize,
                in: minValue...factions.count/settings.players)
    }
    
    private var minValue: Int {
        return (factions.count/settings.players >= 3 ? 3 : 0)
    }
    
    func enableOnPool() -> some View {
        self
            .disabled(settings.pickMethod != .pool)
            .foregroundColor(settings.pickMethod != .pool ? .gray : .black)
    }
}

struct pickMethodRow: View {
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
