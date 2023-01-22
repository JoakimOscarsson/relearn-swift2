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
        ZStack{
            ContentView(menuOpen: $menuOpen)
            MenuView(menuOpen: $menuOpen)
        }.ignoresSafeArea(.all)
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
