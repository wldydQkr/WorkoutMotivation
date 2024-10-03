//
//  CustomTabBar.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/28/24.
//

import SwiftUI

struct CustomTabBar: View {
    @State var selectedTab: Tab = .motivation
    @Namespace private var animation
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab,
                    content:  {
                Text("동기부여")
                    .tag(Tab.motivation)
                Text("좋아요")
                    .tag(Tab.bookmark)
                Text("다짐")
                    .tag(Tab.diary)
                Text("타이머")
                    .tag(Tab.timer)
                Text("설정")
                    .tag(Tab.myPage)
            })
            // CustomTabBar()
        }
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color.blue, _ inactiveTint: Color = .gray) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { item in
                    TabItem(tint: tint, inactiveTint: inactiveTint, tab: item, animation: animation, selectedTab: $selectedTab)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.7), value: selectedTab)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .padding(.top, 25)
        }
    }
}

#Preview {
    CustomTabBar()
}
