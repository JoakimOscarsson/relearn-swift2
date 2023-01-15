//
//  MainView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-14.
//

import SwiftUI

struct MainView: View {
    @State var menuOpen = false
    var body: some View {
        GeometryReader(){ geometry in
            ZStack{
                ContentView()
                
                if !menuOpen { //TODO: When button is in menu, always show it.
                    Button(action: {
                        self.menuOpen.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")}
                    )
                }

                MenuView(menuOpen: $menuOpen, width: geometry.size.width*0.3)
            }.ignoresSafeArea(.all)
        }
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
