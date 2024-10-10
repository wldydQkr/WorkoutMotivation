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
    @State private var shareContent: String = ""
    @State private var headerVisible = true
    @State private var lastScrollPosition: CGFloat = 0.0
    @State private var currentScrollOffset: CGFloat = 0.0
    @State private var showMotivationCardView = false // MotivationCardView 상태

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    let threshold: CGFloat = 70.0

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
                    MotivationCardView(
                        motivations: viewModel.motivations,
                        viewModel: viewModel, // ViewModel 전달
                        showMotivationCardView: $showMotivationCardView
                    )
                } else {
                    ScrollView {
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.lastScrollPosition = geometry.frame(in: .global).minY
                                }
                                .onChange(of: geometry.frame(in: .global).minY) { newValue in
                                    let scrollOffset = newValue - self.lastScrollPosition
                                    self.currentScrollOffset += scrollOffset

                                    // 임계값을 넘었을 때만 애니메이션 트리거
                                    if scrollOffset < 0 && self.currentScrollOffset < -threshold && self.headerVisible {
                                        // 헤더 감추기
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = false
                                        }
                                    } else if scrollOffset > 0 && self.currentScrollOffset > threshold && !self.headerVisible {
                                        // 헤더 보이기
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = true
                                        }
                                    }

                                    // 스크롤이 끝까지 내려갔을 때, 헤더 다시 보이기
                                    if geometry.frame(in: .global).minY >= 0 && !self.headerVisible {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.headerVisible = true
                                        }
                                    }

                                    // currentScrollOffset이 너무 커지지 않도록 리셋
                                    if abs(self.currentScrollOffset) > threshold {
                                        self.currentScrollOffset = 0
                                    }

                                    self.lastScrollPosition = newValue
                                }
                        }
                        .frame(height: 0)

                        if viewModel.isLoading {
                            LottieView("skeletonView")
                                .frame(width: 400, height: 400)
                            LottieView("skeletonView")
                                .frame(width: 400, height: 400)
                        } else {
                            LazyVGrid(columns: columns, spacing: 10) {
                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    ForEach(viewModel.motivations) { motivation in
                                        MotivationItemView(
                                            motivation: motivation,
                                            viewModel: viewModel,
                                            isShareSheetPresented: $isShareSheetPresented,
                                            shareContent: $shareContent
                                        )
                                    }
                                }
                            }
                            .padding([.horizontal, .bottom], 10)
                        }
                    }
                    .background(CustomColor.SwiftUI.customBackgrond)
                    .sheet(isPresented: $isShareSheetPresented) {
                        ShareSheet(activityItems: [shareContent])
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

