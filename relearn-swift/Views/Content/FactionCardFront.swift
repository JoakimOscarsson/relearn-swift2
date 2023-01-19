//
//  FactionCardFront.swift
//  relearn-swift
//
//  Created by Joakim Oscarsson on 2023-01-19.
//

import SwiftUI

struct FactionCardFront: View {
    let faction: Binding<Faction?>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                CardShape(cardBackground: CustomColors.factionCardBackground, cardWidth: geometry.size.width)

                VStack(spacing: 0){
                    factionHeader(cardWidth: geometry.size.width)

                    factionImage()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: UIConstants.imageScaler*geometry.size.width,
                            height: UIConstants.imageScaler*geometry.size.height
                        )
                }
            }
        }.aspectRatio(0.714, contentMode:.fit)
    }
    
    func factionHeader(cardWidth: CGFloat) -> some View {
        var body: some View {
            Text(faction.wrappedValue?.name ?? "Faction not found")
                .font(.custom("FactionHead",size: cardWidth*0.12))
                .padding(.top, cardWidth*0.1)
        }
        return body
    }
        
    func factionImage() -> Image {
        if faction.wrappedValue != nil {
            if faction.wrappedValue!.image != nil {
                if UIImage(named: faction.wrappedValue!.image!) != nil {
                    return Image(faction.wrappedValue!.image!)
                }
            }
        }
        return Image(systemName: "square.dashed")
    }
}

//struct FactionCardFrontPreviewer: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    let rawFaction = codableFaction(name: "Aliens", image: "Aliens", description: "A faction of Aliens")
//    var body: some View {
//        FactionCardFront(faction: Faction(in: viewContext, from: rawFaction))
//    }
//}
//
//
//struct FactionCardFront_Previews: PreviewProvider {
//    static var previews: some View {
//        FactionCardFrontPreviewer()
//    }
//}
