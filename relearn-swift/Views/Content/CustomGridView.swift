//
//  smartGridView.swift
//  smash up team randomizer
//
//  Created by Joakim Oscarsson on 2021-07-18.
//  Copyright © 2021 Joakim Oscarsson. All rights reserved.
//

import SwiftUI


struct CustomGridView<Item, ItemView>: View where ItemView : View, Item : Identifiable {
    var items: [Item]
    var content: (Item) -> ItemView

    
    @ViewBuilder var body: some View {
        GeometryReader { geometry in
            
            let minWidthForTwo: CGFloat = 700
            //1: one column, scroll
            if geometry.size.width < minWidthForTwo {
                ZStack{ //TODO: Remove this?
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(items){ item in
                                content(item).frame(
                                    maxWidth: geometry.size.width,
                                    maxHeight: geometry.size.height)
                            }
                        }
                    }
                }
            //2: Two columns
            } else {
                HStack {
                    Spacer()
                    VStack{
                        Spacer()
                        if items.count != 3 {
                            LazyVGrid(columns: [GridItem(), GridItem()]){
                                ForEach(items){ item in
                                    content(item).frame(
                                        maxWidth: geometry.size.width,
                                        maxHeight: geometry.size.height)
                                }
                            }.aspectRatio(ratio(), contentMode: .fit)
                        } else {
                            VStack {
                                LazyVGrid(columns: [GridItem(), GridItem()]){
                                    ForEach(items[..<2]){ item in
                                        content(item).frame(
                                            maxWidth: geometry.size.width,
                                            maxHeight: geometry.size.height)
                                    }
                                }
                                content(items[2])
                            }.aspectRatio(ratio(), contentMode: .fit)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    func ratio() -> CGFloat {
        return (items.count > 2 ? 1 : 2)
    }
    
//    @ViewBuilder var body: some View {
//        GeometryReader {geometry in
//            ScrollView{
////            VStack{
//                if geometry.size.width < 2 * UIConstants.teamBoxMaxWidth { //TODO: Add check to see if height allows for removing scrollview
//                    LazyVGrid(columns: [GridItem()]){loopContent(for: items)}
//                }else if items.count == 3 {
//                    LazyVGrid(columns: mirroredGridItems(), spacing: 0){loopContent(for: Array(items[0..<2]))}
//                    LazyVGrid(columns: [GridItem()]){loopContent(for: Array(items[2..<items.endIndex]))}
//                }else {
//                    LazyVGrid(columns: mirroredGridItems()){loopContent(for: items)}
//                }
//            }
//        }
//    }
//
//    private func mirroredGridItems() -> [GridItem]{
//        func preppedGridItem(_ alignment: Alignment) -> GridItem {
//            var gridItem = GridItem()
//            gridItem.alignment = alignment
//            return gridItem
//        }
//        return [preppedGridItem(Alignment.trailing), preppedGridItem(Alignment.leading)]
//    }
//
//    private func loopContent(for items: [Item]) -> some View{
//        ForEach(items) {item in content(item).frame(maxWidth: UIConstants.teamBoxMaxWidth)}
//    }
}


struct CustomGridPreviewer: View {
    @Environment(\.managedObjectContext) private var viewContext
    let rawFaction = codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aliens")
    var body: some View {
        let test = [
            Team(id: "Player 1",
                  faction1: Faction(in: viewContext, from: rawFaction),
                  faction2: Faction(in: viewContext, from: rawFaction)),
            Team(id: "Player 2",
                  faction1: Faction(in: viewContext, from: rawFaction),
                  faction2: Faction(in: viewContext, from: rawFaction)),
            Team(id: "Player 3",
                  faction1: Faction(in: viewContext, from: rawFaction),
                  faction2: Faction(in: viewContext, from: rawFaction))
            ]
        
        HStack{
            CustomGridView(items: test){team in
                teamView(team: team)
            }
        }
    }
}

struct smartGridView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGridPreviewer().ignoresSafeArea(.all)
    }
}
