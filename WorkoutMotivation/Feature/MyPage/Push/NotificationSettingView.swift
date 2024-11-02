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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            CustomHeaderView(title: "알림 설정") {
                Button("뒤로가기") {
                    viewModel.scheduleNotifications()
                    presentationMode.wrappedValue.dismiss() // 이전 뷰로 돌아감
                }
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.notifications.indices, id: \.self) { index in
                        NotificationRow(notification: $viewModel.notifications[index]) {
                            viewModel.removeNotification(at: IndexSet(integer: index))
                        }
                    }
                    Button(action: {
                        viewModel.addNotification()
                    }) {
                        Text("알림 추가")
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.notifications.count >= 12) // 최대 12개까지 제한
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("알림 추가 불가"), message: Text("최대 12개의 알림만 추가할 수 있습니다."), dismissButton: .default(Text("확인")))
            }
        }
        .navigationBarHidden(true)
    }
}

struct NotificationRow: View {
    @Binding var notification: NotificationItem
    var onDelete: () -> Void // 삭제 버튼 클릭 시 호출할 클로저

    var body: some View {
        HStack {
            DatePicker("알림 시간", selection: $notification.date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(width: 120)

            Text(notification.motivation?.title ?? "명언 타이틀")
                .foregroundColor(.gray)

            Toggle("반복", isOn: $notification.repeats)
                .toggleStyle(SwitchToggleStyle(tint: .blue))

            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
#Preview {
    NotificationSettingView()
}
