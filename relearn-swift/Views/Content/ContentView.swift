//
//  ContentView.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-15.
//

import SwiftUI

//TODO: remove this and make some other smart thing for the preview
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
