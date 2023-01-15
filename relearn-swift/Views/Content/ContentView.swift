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
    @Binding var menuOpen: Bool
    let test = [Team(id: "player 1"), Team(id: "player 2"), Team(id: "player 3")]
    var body: some View {
        ZStack{
            CustomColors.appBackground
            VStack{
                HStack{
                    Button(action: toggleMenu) {
                        Image(systemName: "sidebar.left")
                            .resizable()
                            .aspectRatio(UIImage(systemName: "sidebar.left")!.size, contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .padding(.all, 20)
                    }
                    Spacer()
                }
                
                CustomGridView(items: test){team in
                    TeamView(team: team)
                }
            }
        }
    }
    
    func toggleMenu(){
        self.menuOpen.toggle()
    }
}

struct ContentViewPreviewer: View {
    @State private var dummy = false
    var body: some View {
        ContentView(menuOpen: $dummy)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewPreviewer().ignoresSafeArea(.all)
    }
}
