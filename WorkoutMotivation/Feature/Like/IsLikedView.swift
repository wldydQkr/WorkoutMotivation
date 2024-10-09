//
//  isLikedView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct IsLikedView: View {
    @ObservedObject var motivationViewModel: MotivationViewModel
    @ObservedObject var viewModel: IsLikedViewModel

    @State private var headerVisible = true
    @State private var lastScrollPosition: CGFloat = 0.0
    @State private var currentScrollOffset: CGFloat = 0.0

    let threshold: CGFloat = 70.0 // 스크롤 민감도

    var body: some View {
        NavigationView {
            VStack {
                if headerVisible {
                    CustomHeaderView(title: "좋아하는 명언") {
                        DelButton()
                    }
                        .transition(.move(edge: .top))
                }

                List {
                    //MARK: 스크롤 시 헤더 숨기기
//                    GeometryReader { geometry in
//                        Color.clear // 보이지 않게 처리
//                            .frame(height: 1) // 최소 크기로 설정하여 이상한 빈 공간 방지
//                            .onAppear {
//                                self.lastScrollPosition = geometry.frame(in: .global).minY
//                            }
//                            .onChange(of: geometry.frame(in: .global).minY) { value in
//                                let scrollOffset = value - self.lastScrollPosition
//                                self.currentScrollOffset += scrollOffset
//
//                                // 스크롤이 아래로 내려가면 헤더 숨기기
//                                if self.currentScrollOffset < -threshold {
//                                    withAnimation {
//                                        self.headerVisible = false
//                                    }
//                                }
//                                // 스크롤이 위로 올라가면 헤더 보이기
//                                else if self.currentScrollOffset > threshold {
//                                    withAnimation {
//                                        self.headerVisible = true
//                                    }
//                                }
//
//                                // 맨 위로 도달하면 헤더 보이기
//                                if geometry.frame(in: .global).minY >= 0 {
//                                    withAnimation {
//                                        self.headerVisible = true
//                                    }
//                                }
//
//                                // 스크롤 오프셋을 초기화하여 지나치게 민감하지 않게 설정
//                                if abs(self.currentScrollOffset) > threshold {
//                                    self.currentScrollOffset = 0
//                                }
//
//                                self.lastScrollPosition = value
//                            }
//                    }
//                    .frame(height: 0) // GeometryReader가 차지하는 공간을 없앰

                    if motivationViewModel.isLoading {
                        ProgressView("로딩 중...")
                            .padding()
                    } else if motivationViewModel.likedMotivations.isEmpty {
                        Text("아직 좋아요를 누른 항목이 없습니다.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(motivationViewModel.motivations.filter { motivationViewModel.isLiked($0) }) { motivation in
                            IsLikedMotivationItemView(
                                viewModel: motivationViewModel,
                                motivation: motivation
                            )
                            .contentShape(Rectangle()) // 전체 영역이 탭 가능하도록 설정
                            .onTapGesture {
                                navigateToDetailView(for: motivation)
                            }
                            .listRowSeparator(.hidden) // 구분선 숨기기
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .listStyle(PlainListStyle())
                .background(CustomColor.SwiftUI.customBackgrond)
                .refreshable {
                    await motivationViewModel.reload() // 새로고침 시 호출할 함수
                }
            }
            .background(CustomColor.SwiftUI.customBackgrond)
            .navigationBarHidden(true) // 네비게이션 바 숨기기
            .onAppear {
                motivationViewModel.loadLikedMotivations() // 좋아요 상태 갱신
            }
        }
    }
    
    private func navigateToDetailView(for motivation: Motivation) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else { return }

        let vc = MotivationDetailView(title: motivation.title, name: motivation.name, motivation: motivation, viewModel: motivationViewModel)
        let hostingController = UIHostingController(rootView: vc)
        rootViewController.present(hostingController, animated: true, completion: nil)
    }

    private func deleteItems(at offsets: IndexSet) {
        let idsToRemove = offsets.map { motivationViewModel.motivations.filter { motivationViewModel.isLiked($0) }[$0].id }
        motivationViewModel.likedMotivations.removeAll(where: { idsToRemove.contains($0) })
    }

    
}

#Preview {
    IsLikedView(motivationViewModel: MotivationViewModel(), viewModel: IsLikedViewModel())
}
