//
//  MainView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-14.
//

import SwiftUI

struct tmp: Identifiable {
    var id = UUID()
}

struct ContentView: View {
    let test = [Team(id: "player 1"), Team(id: "player 2"), Team(id: "player 3")]
    var body: some View {
        ZStack{
            CustomColors.appBackground
            CustomGridView(items: test){team in
                TeamView(team: team)
            }
        }
        
        
    }
}

struct MainView: View {
    @State var menuOpen = false
    var body: some View {
        GeometryReader(){ geometry in
            ZStack{
                VStack{
                    Spacer()
                    ContentView().ignoresSafeArea(.all)
                    
                }
                if !menuOpen { //TODO: When button is in menu, always show it.
                    Button(action: {
                        self.menuOpen.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")}
                    )
                }

                MenuView(menuOpen: $menuOpen, width: geometry.size.width*0.3)
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

struct MenuItem: Identifiable {
    let id = UUID()
    let text: String
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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
