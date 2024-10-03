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
                CustomHeader()
                
                List(viewModel.items) { item in
                    if item.title == "앱 버전" {
                        NavigationLink(destination: AppVersionView()) {
                            Text(item.title)
                        }
                    } else if item.title == "알림 설정" {
                        NavigationLink(destination: PushSettingView()) {
                            Text(item.title)
                        }
                    } else {
                        Button(action: {
                            if item.title == "앱 공유" {
                                viewModel.shareApp()
                            } else {
                                item.action()
                            }
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

struct CustomHeader: View {
    var body: some View {
        HStack {
            Text("마이페이지")
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
        .background(CustomColor.SwiftUI.customBackgrond)
        .foregroundColor(.white)
    }
}

#Preview {
    MyPageView()
}
