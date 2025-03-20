//
//  OnboardingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .customBlack // 현재 페이지 색상
        UIPageControl.appearance().pageIndicatorTintColor = .customBlack3.withAlphaComponent(0.5) // 기본 색상
    }
    
    var body: some View {
        if hasSeenOnboarding {
            HomeView()
                .navigationBarBackButtonHidden(true)
        } else {
            NavigationStack(path: $pathModel.paths) {
                OnboardingContentView(onboardingViewModel: onboardingViewModel)
                    .background(CustomColor.SwiftUI.customBackgrond)
                    .navigationDestination(
                        for: PathType.self,
                        destination: { pathType in
                            switch pathType {
                            case .homeView:
                                HomeView()
                                    .navigationBarBackButtonHidden(true)
                                
                            default:
                                EmptyView()
                            }
                        }
                    )
            }
            .environmentObject(pathModel)
        }
    }
}

// MARK: - 시작하기 버튼 뷰
struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @Binding var selectedIndex: Int
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        Button(
            action: {
                if selectedIndex < onboardingViewModel.onboardingContents.count - 1 {
                    selectedIndex += 1
                } else {
                    hasSeenOnboarding = true
                    pathModel.paths.append(.homeView)
                }
            },
            label: {
                HStack {
                    Text("시작하기")
                        .frame(width: 180, height: 80)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CustomColor.SwiftUI.customBackgrond)
                        .background(CustomColor.SwiftUI.customBlack)
                        .cornerRadius(40)
                }
            }
        )
        .padding(.bottom, 50)
        .shadow(radius: 7)
    }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            OnboardingCellListView(onboardingViewModel: onboardingViewModel, selectedIndex: $selectedIndex)
            
            Spacer()
            
            StartBtnView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent, isLottie: index == 0)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(selectedIndex % 2 == 0 ? CustomColor.SwiftUI.customBackgrond : CustomColor.SwiftUI.customBackgrond)
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    var onboardingContent: OnboardingContent
    var isLottie: Bool
    
    var body: some View {
        VStack {
            if isLottie {
                LottieView(onboardingContent.imageFileName)
                    .frame(width: 150.0, height: 150, alignment: .center)
                    .shadow(radius: 2)
            } else {
                Image(onboardingContent.imageFileName)
                    .resizable()
                    .frame(width: 150.0, height: 150.0, alignment: .center)
                    .shadow(radius: 2)
            }
            
            HStack {
                VStack {
                    Spacer()
                        .frame(height: 50)
                    Text(onboardingContent.content)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CustomColor.SwiftUI.customBlack)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .background(CustomColor.SwiftUI.customBackgrond)
        }
    }
}

#Preview {
    OnboardingView()
}
