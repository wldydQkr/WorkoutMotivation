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
    @State private var isShareSheetPresented = false
    
    var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "설정") {
                    EmptyView()
                }
                
                List(viewModel.items) { item in
                    switch item.title {
                    case "앱 버전":
                        // NavigationLink(destination: AppVersionView()) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            Text(appVersion)
                                .foregroundStyle(CustomColor.SwiftUI.customBlack3)
                        }
                        // }
                    case "알림 설정":
                        NavigationLink(destination: NotificationSettingView()) {
                            Text(item.title)
                        }
                    case "타이머":
                        NavigationLink(destination: TimerView()) {
                            Text(item.title)
                        }
                    case "앱 공유":
                        Button(action: {
                            viewModel.shareApp()
                            isShareSheetPresented = true
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
                ShareSheet(activityItems: viewModel.activityItems, isPresented: $isShareSheetPresented)
            }
        }
    }
}


#Preview {
    MyPageView()
}
