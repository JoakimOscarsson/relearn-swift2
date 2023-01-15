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
        GeometryReader {geometry in
            ScrollView{
                if geometry.size.width < 2 * UIConstants.teamBoxMaxWidth { //TODO: Add check to see if height allows for removing scrollview
                    LazyVGrid(columns: [GridItem()]){loopContent(for: items)}
                }else if items.count == 3 {
                    LazyVGrid(columns: mirroredGridItems(), spacing: 0){loopContent(for: Array(items[0..<2]))}
                    LazyVGrid(columns: [GridItem()]){loopContent(for: Array(items[2..<items.endIndex]))}
                }else {
                    LazyVGrid(columns: mirroredGridItems()){loopContent(for: items)}
                }
            }
        }
    }
    
    private func mirroredGridItems() -> [GridItem]{
        func preppedGridItem(_ alignment: Alignment) -> GridItem {
            var gridItem = GridItem()
            gridItem.alignment = alignment
            return gridItem
        }
        return [preppedGridItem(Alignment.trailing), preppedGridItem(Alignment.leading)]
    }
    
    private func loopContent(for items: [Item]) -> some View{
        ForEach(items) {item in content(item).frame(maxWidth: UIConstants.teamBoxMaxWidth)}
    }
}

//struct smartGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        smartGridView()
//    }
//}
