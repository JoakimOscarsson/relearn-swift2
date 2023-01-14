//
//  MainView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-14.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        EmptyView()
    }
}

struct MainView: View {
    @State var menuOpen = false
    var body: some View {
        GeometryReader(){ geometry in
            ZStack{
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
            .animation(.easeIn(duration: 0.1), value: menuOpen)
            
            
            // Menu
            HStack{
                NavigationStack{
                    MenuContentView(menuOpen: $menuOpen)
                }
                    .frame(width: width)
                    .offset(x: menuOpen ? 0 : -width)
                    .animation(.easeIn(duration: 0.1), value: menuOpen)
                Spacer()
            }
            .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {menuOpen.toggle()}
                })
        }
    }
}

struct MenuContentView: View {
    @Binding var menuOpen: Bool
    let menuItems = [
        MenuItem(text: "Sets"),
        MenuItem(text: "Mechanics "),
        MenuItem(text: "Factions")
    ]
    
    var body: some View {
        Form{
            ForEach(menuItems) { item in
                Text(item.text)
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

struct MenuItem: Identifiable {
    let id = UUID()
    let text: String
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
