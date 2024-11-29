//
//  HomeTabView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var motivationViewModel = MotivationViewModel()
    @StateObject private var isLikedViewModel = IsLikedViewModel()
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: -70) {
            TabView(selection: $viewModel.selectedTab) {
                MotivationView(viewModel: motivationViewModel)
                    .tag(Tab.motivation)
                
                IsLikedView(motivationViewModel: motivationViewModel, viewModel: isLikedViewModel)
                    .tag(Tab.bookmark)
                
                DiaryView()
                    .tag(Tab.diary)
                
                WorkoutClassView()
                    .tag(Tab.timer)
                
                MyPageView()
                    .tag(Tab.myPage)
            }
            CustomTabBar()
        }
        .environmentObject(viewModel)
        .accentColor(.clear)
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = CustomColor.SwiftUI.customGreen, _ inactiveTint: Color = .gray) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { item in
                TabItem(tint: tint, inactiveTint: inactiveTint, tab: item, animation: animation, selectedTab: $viewModel.selectedTab)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 3)
        //TODO: Animation 렉 이슈 (damping 조절 아니면 그냥 애니메이션 삭제 고려)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.7), value: viewModel.selectedTab)
        .background {
            Rectangle()
                .fill(.customBackground)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .padding(.top, 20)
        }
    }
}

//struct HomeView: View {
//    @EnvironmentObject private var pathModel: PathModel
//    @StateObject private var viewModel = HomeViewModel()
//    @StateObject private var motivationViewModel = MotivationViewModel()
//    @StateObject private var isLikedViewModel = IsLikedViewModel()
////    @ObservedObject var viewModel: HomeViewModel
//    
//    init() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = CustomColor.UIKit.customBackground
//        UITabBar.appearance().standardAppearance = appearance
//        if #available(iOS 15.0, *) {
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        }
//    }
//    
//    var body: some View {
//        TabView(selection: $viewModel.selectedTab) {
//            MotivationView(viewModel: motivationViewModel)
//                .tabItem {
//                    Image(systemName:
//                            viewModel.selectedTab == .motivation ? "flame.fill" : "flame"
//                    )
//                    Text("동기부여")
//                }
//                .tag(Tab.motivation)
//            
//            IsLikedView(motivationViewModel: motivationViewModel, viewModel: isLikedViewModel)
//                .tabItem {
//                    Image(systemName:
//                            viewModel.selectedTab == .bookmark ? "heart.fill" : "heart"
//                    )
//                    Text("좋아요")
//                }
//                .tag(Tab.bookmark)
//            
//            DiaryView()
//                .tabItem {
//                    Image(systemName:
//                            viewModel.selectedTab == .diary ? "book.closed" : "book.closed.fill"
//                    )
//                    Text("다짐")
//                }
//                .tag(Tab.diary)
//            
//            TimerView()
//                .tabItem {
//                    Image(systemName:
//                            viewModel.selectedTab == .timer ? "timer" : "timer"
//                    )
//                    Text("타이머")
//                }
//                .tag(Tab.timer)
//            
//            MyPageView()
//                .tabItem {
//                    Image(systemName:
//                            viewModel.selectedTab == .myPage ? "gearshape.fill" : "gearshape"
//                    )
//                    Text("설정")
//                }
//                .tag(Tab.myPage)
//            
//        }
//        .environmentObject(viewModel)
//        .accentColor(CustomColor.SwiftUI.customGreen)
//    }
//}

#Preview {
    HomeView()
}
