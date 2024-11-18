//
//  MotivationView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/2/24.
//

import SwiftUI

struct MotivationView: View {
    @ObservedObject var viewModel: MotivationViewModel
    @State private var isShareSheetPresented = false
    @State private var shareContent: String = "Hello, world!"
    @State private var headerVisible = true
    @State private var lastScrollPosition: CGFloat = 0.0
    @State private var currentScrollOffset: CGFloat = 0.0
    @State private var showMotivationCardView = true

    let threshold: CGFloat = 70.0
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if headerVisible {
                    CustomHeaderView(title: "동기부여", buttonImage: Image("memo"), buttonAction: {
                        withAnimation {
                            showMotivationCardView.toggle()
                        }
                    }) {
                        EmptyView()
                    }
                    .transition(.move(edge: .top))
                }
                
                if showMotivationCardView {
                    if viewModel.isLoading {
                        VStack(spacing: 0) {
                            LottieView("skeletonView")
                                .frame(width: 350, height: 350)
                                .background(CustomColor.SwiftUI.customBackgrond)
                            LottieView("skeletonView")
                                .frame(width: 350, height: 350)
                                .background(CustomColor.SwiftUI.customBackgrond)
                        }
                        
                    } else {
                        MotivationCardView(
                            motivations: viewModel.motivations,
                            viewModel: viewModel,
                            showMotivationCardView: $showMotivationCardView,
                            isShareSheetPresented: $isShareSheetPresented,
                            shareContent: $shareContent
                            
                        )
                        .onChange(of: shareContent) { oldValue, newValue in
                            if !newValue.isEmpty {
                                isShareSheetPresented = true
                            }
                        }
                        .sheet(isPresented: $isShareSheetPresented) {
                            ShareSheet(activityItems: [shareContent], isPresented: $isShareSheetPresented)
                        }
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        //MARK: 스크롤 시 헤더 숨김
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.lastScrollPosition = geometry.frame(in: .global).minY
                                }
                                .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                                    let scrollOffset = newValue - self.lastScrollPosition
                                    self.currentScrollOffset += scrollOffset
                                    
                                    if scrollOffset < 0 && self.currentScrollOffset < -threshold && self.headerVisible {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = false
                                        }
                                    } else if scrollOffset > 0 && self.currentScrollOffset > threshold && !self.headerVisible {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = true
                                        }
                                    }
                                    
                                    if geometry.frame(in: .global).minY >= 0 && !self.headerVisible {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = true
                                        }
                                    }
                                    
                                    if abs(self.currentScrollOffset) > threshold {
                                        self.currentScrollOffset = 0
                                    }
                                    
                                    self.lastScrollPosition = newValue
                                }
                        }
                        .frame(height: 0)
                        
                        if viewModel.isLoading {
                            VStack(spacing: 0) {
                                LottieView("skeletonView")
                                    .frame(width: 350, height: 350)
                                    .background(CustomColor.SwiftUI.customBackgrond)
                                LottieView("skeletonView")
                                    .frame(width: 350, height: 350)
                                    .background(CustomColor.SwiftUI.customBackgrond)
                            }
                        } else {
                            MasonryVStack(columns: 2, spacing: 10) {
                                ForEach(viewModel.motivations, id: \.id) { motivation in
                                    MotivationItemView(
                                        motivation: motivation,
                                        viewModel: viewModel,
                                        isShareSheetPresented: $isShareSheetPresented,
                                        shareContent: $shareContent
                                    )
                                }
                            }
                            .padding([.horizontal, .bottom], 10)
                        }
                    }
                    .background(CustomColor.SwiftUI.customBackgrond)
                    .sheet(isPresented: $isShareSheetPresented) {
                        ShareSheet(activityItems: [shareContent], isPresented: $isShareSheetPresented)
                    }
                    .onChange(of: shareContent) { oldValue, newValue in
                        if !newValue.isEmpty {
                            isShareSheetPresented = true
                        }
                    }
                    .refreshable {
                        await viewModel.reload()
                    }
                    .onAppear {
                        viewModel.loadLikedMotivations() // 좋아요 상태 갱신
                    }
                }
            }
            .background(CustomColor.SwiftUI.customBackgrond)
        }
    }
}

#Preview {
    MotivationView(viewModel: MotivationViewModel())
}
