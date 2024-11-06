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
    @State private var isFloatingListPresented = false
    @State private var selectedIndex: Int? = nil

    var body: some View {
        VStack {
            CustomHeaderView(title: "알림 설정") {
                Button("뒤로가기") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.notifications.indices, id: \.self) { index in
                        NotificationRow(
                            notification: $viewModel.notifications[index],
                            onDelete: {
                                viewModel.showDeleteConfirmation(for: index)
                            }, viewModel: viewModel
                        )
                    }
                    
                    Button(action: {
                        viewModel.addNotification()
                    }) {
                        Text("알림 추가")
                            .foregroundColor(viewModel.notifications.count >= 12 ? CustomColor.SwiftUI.customGreen4 : CustomColor.SwiftUI.customWhite)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.notifications.count >= 12 ? CustomColor.SwiftUI.customGreen4.opacity(0.2) : CustomColor.SwiftUI.customBlack)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.notifications.count >= 12)
                }
                .padding()
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
        .background(Color.gray.opacity(0.1))
        .navigationBarHidden(true)
        .sheet(isPresented: $isFloatingListPresented) {
            if let index = selectedIndex {
                FloatingMotivationListView(
                    selectedMotivation: $viewModel.notifications[index].motivation,
                    isPresented: $isFloatingListPresented,
                    notification: viewModel.notifications[index],
                    viewModel: viewModel
                )
            }
        }
        .onAppear {
            viewModel.reloadLikedMotivations()
        }
    }
}

struct NotificationRow: View {
    @Binding var notification: NotificationItem
    @State private var showMotivationList = false
    var onDelete: () -> Void
    @ObservedObject var viewModel: NotificationSettingViewModel // ViewModel을 전달받음
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DatePicker("알림 시간", selection: $notification.date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 120)
                    .onChange(of: notification.date) { oldData, newDate in
                        viewModel.updateNotification(for: notification) // 시간 변경 즉시 알림 업데이트
                    }

                Toggle("", isOn: $notification.repeats)
                    .toggleStyle(SwitchToggleStyle(tint: CustomColor.SwiftUI.customBlack))

                Spacer()

                Button(action: {
                    onDelete() // 삭제 알럿 표시
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }

            HStack {
                Spacer()
                Button(action: {
                    showMotivationList.toggle()
                }) {
                    Text(notification.motivation?.title ?? "명언 선택")
                        .foregroundColor(CustomColor.SwiftUI.customBlack)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
            }
            .sheet(isPresented: $showMotivationList) {
                FloatingMotivationListView(
                    selectedMotivation: $notification.motivation,
                    isPresented: $showMotivationList,
                    notification: notification,
                    viewModel: viewModel
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct FloatingMotivationListView: View {
    @Binding var selectedMotivation: Motivation?
    @Binding var isPresented: Bool
    var notification: NotificationItem // 선택한 알림을 넘겨받음
    @ObservedObject var viewModel: NotificationSettingViewModel // ViewModel을 전달받음

    var body: some View {
        NavigationView {
            List(viewModel.likedMotivations, id: \.id) { motivation in
                Button(action: {
                    selectedMotivation = motivation
                    viewModel.rescheduleNotification(for: notification, with: motivation) // 알림 재예약
                    isPresented = false
                }) {
                    VStack(alignment: .leading) {
                        Text(motivation.title)
                            .font(.headline)
                            .foregroundStyle(CustomColor.SwiftUI.customBlack)
                        Text(motivation.name)
                            .font(.subheadline)
                            .foregroundColor(CustomColor.SwiftUI.customGreen4)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationBarTitle("좋아하는 명언 선택", displayMode: .inline)
            .navigationBarItems(trailing: Button("닫기") {
                isPresented = false
            })
        }
    }
}

#Preview {
    NotificationSettingView()
}
