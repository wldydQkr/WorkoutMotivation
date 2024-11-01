//
//  NotificationSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import SwiftUI
import UserNotifications

struct NotificationSettingView: View {
    @StateObject private var viewModel = NotificationSettingViewModel()
    @Environment(\.presentationMode) var presentationMode // 이전 뷰로 돌아가기 위한 환경 변수

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notifications.indices, id: \.self) { index in
                    HStack {
                        DatePicker("알림 시간", selection: $viewModel.notifications[index].date, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Text(viewModel.notifications[index].motivation?.title ?? "동기부여 제목 없음")
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: viewModel.removeNotification)
                
                Button(action: {
                    viewModel.addNotification()
                }) {
                    Text("알림 추가")
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.notifications.count >= 12) // 최대 12개까지 제한
            }
            .navigationTitle("알림 설정")
            .navigationBarItems(trailing: HStack {
                Button("설정 완료") {
                    viewModel.scheduleNotifications()
                    presentationMode.wrappedValue.dismiss() // 이전 뷰로 돌아감
                }
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .disabled(viewModel.notifications.isEmpty) // 알림이 없으면 비활성화
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("알림 추가 불가"), message: Text("최대 12개의 알림만 추가할 수 있습니다."), dismissButton: .default(Text("확인")))
            }
        }
    }
}

#Preview {
    NotificationSettingView()
}
