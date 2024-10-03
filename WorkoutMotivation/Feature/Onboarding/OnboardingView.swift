//
//  OnboardingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import SwiftUI

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            // 온보딩을 이미 본 경우 메인 화면으로 이동
            HomeView()
                .navigationBarBackButtonHidden(true)
        } else {
            // 온보딩을 아직 보지 않은 경우 온보딩 화면 표시
            NavigationStack(path: $pathModel.paths) {
                OnboardingContentView(onboardingViewModel: onboardingViewModel)
                    .background(CustomColor.SwiftUI.customBackgrond)
                    .navigationDestination(
                        for: PathType.self,
                        destination: { pathType in
                            switch pathType {
                            case .homeView:
                                HomeView()
                                    .navigationBarBackButtonHidden()
                                
                            case .todoView:
                                HomeView()
                                    .navigationBarBackButtonHidden()
                            }
                        }
                    )
            }
            .environmentObject(pathModel)
        }
    }
}

// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    fileprivate var body: some View {
        Button(
            action: {
                // 온보딩 완료 상태를 저장
                hasSeenOnboarding = true
                // 홈 화면으로 이동
                pathModel.paths.append(.homeView)
            },
            label: {
                HStack {
                    Text("시작하기")
                        .frame(width: 180, height: 80)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CustomColor.SwiftUI.customBackgrond)
                        .background(CustomColor.SwiftUI.customGreen)
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
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            // 시작 버튼 뷰
            StartBtnView()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex = 0
    
    init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(selectedIndex % 2 == 0 ? CustomColor.SwiftUI.customBackgrond : Color.green)
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            LottieView(onboardingContent.imageFileName)
                .frame(width: 150.0, height: 150)
                .shadow(radius: 2)
            HStack {
                Spacer()
                    .frame(width: 36)
                VStack {
                    Spacer()
                        .frame(height: 60)
                    
                    Text(onboardingContent.content)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(CustomColor.SwiftUI.customGreen)
//                    Spacer()
//                        .frame(height: 0)
                }
                
                Spacer()
            }
            .background(CustomColor.SwiftUI.customBackgrond)
        }
    }
}

#Preview {
    OnboardingView()
}
