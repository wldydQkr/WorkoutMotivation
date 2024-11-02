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
//    @StateObject private var motivationViewModel = MotivationViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            CustomHeaderView(title: "알림 설정") {
                Button("뒤로가기") {
                    viewModel.scheduleNotifications()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.notifications.indices, id: \.self) { index in
                        NotificationRow(notification: $viewModel.notifications[index], likedMotivations: viewModel.likedMotivations) {
                            viewModel.showDeleteConfirmation(for: index)
                        }
                    }
                    Button(action: {
                        viewModel.addNotification()
                    }) {
                        Text("알림 추가")
                            .foregroundColor(viewModel.notifications.count >= 12 ? .gray : .blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.notifications.count >= 12 ? Color.gray.opacity(0.2) : Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.notifications.count >= 12)
                }
                .padding()
            }
            .onChange(of: viewModel.likedMotivations) { _ in
                viewModel.reloadLikedMotivations() // 좋아요한 명언 리스트 업데이트
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("알림 추가 불가"), message: Text("최대 12개의 알림만 추가할 수 있습니다."), dismissButton: .default(Text("확인")))
            }
            .alert(isPresented: $viewModel.showDeleteAlert) {
                Alert(
                    title: Text("알림 삭제"),
                    message: Text("정말 이 알림을 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        viewModel.confirmDelete()
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
        .background(CustomColor.SwiftUI.customBackgrond)
        .navigationBarHidden(true)
    }
}

struct NotificationRow: View {
    @Binding var notification: NotificationItem
    var likedMotivations: [Motivation]
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                DatePicker("알림 시간", selection: $notification.date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 120)
                Toggle("", isOn: $notification.repeats)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            VStack(alignment: .leading) {
                Text("알림 내용 선택")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Picker("알림 내용 선택", selection: $notification.motivation) {
                    Text("명언 선택").tag(nil as Motivation?)
                    ForEach(likedMotivations, id: \.id) { motivation in
                        Text(motivation.title).foregroundColor(.primary).tag(motivation as Motivation?)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            HStack {
                Spacer()
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
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    NotificationSettingView()
}
