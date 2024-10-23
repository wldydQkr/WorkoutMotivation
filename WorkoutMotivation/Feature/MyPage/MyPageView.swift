//
//  MyPageView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/9/24.
//

import SwiftUI
import MessageUI

struct MyPageView: View {
    @ObservedObject var viewModel = MyPageViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "설정") {
                    EmptyView()
                }
                
                List(viewModel.items) { item in
                    switch item.title {
                    case "앱 버전":
                        NavigationLink(destination: AppVersionView()) {
                            Text(item.title)
                        }
                    case "알림 설정":
                        NavigationLink(destination: PushSettingView()) {
                            Text(item.title)
                        }
                    case "앱 공유":
                        Button(action: {
                            viewModel.shareApp()
                        }) {
                            Text(item.title)
                        }
                    default:
                        Button(action: {
                            item.action()
                        }) {
                            Text(item.title)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(CustomColor.SwiftUI.customBackgrond)
            }
            .background(CustomColor.SwiftUI.customBackgrond)
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.isShowingMailView) {
                MailView(isShowing: $viewModel.isShowingMailView, result: $viewModel.mailResult)
            }
            .sheet(isPresented: $viewModel.isShowingShareSheet) {
                ShareSheet(activityItems: viewModel.activityItems)  // 공유할 아이템 전달
            }
        }
    }
}

#Preview {
    MyPageView()
}
