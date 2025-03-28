//
//  TabItem.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/30/24.
//

import SwiftUI

struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack {
            Image(systemName: tab.systemImage)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
                .font(.title2)
                .foregroundColor(selectedTab == tab ? CustomColor.SwiftUI.customBlack : inactiveTint)
                .frame(width: selectedTab == tab ? 58 : 35, height: selectedTab == tab ? 58 : 35)
//                .padding(50)
                .background {
                    if selectedTab == tab {
                        Circle().fill(CustomColor.SwiftUI.customBackgrond.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(selectedTab == tab ? CustomColor.SwiftUI.customBlack : inactiveTint)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTab = tab
        }
    }
}


//struct TabItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TabItem()
//    }
//}
