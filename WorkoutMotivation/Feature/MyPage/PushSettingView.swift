//
//  PushSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import SwiftUI

struct PushSettingView: View {
    @StateObject private var motivationViewModel = MotivationViewModel()
    @StateObject private var pushSettingViewModel = PushSettingViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                PushSettingHeaderView()
                
                // 알림 활성화/비활성화 토글
                Toggle(isOn: $pushSettingViewModel.isNotificationEnabled) {
                    Text(pushSettingViewModel.isNotificationEnabled ? "알림 켜짐" : "알림 꺼짐")
                        .font(.headline)
                        .foregroundColor(pushSettingViewModel.isNotificationEnabled ? .green : .red)
                }
                .padding()
                .onChange(of: pushSettingViewModel.isNotificationEnabled) { newValue in
                    pushSettingViewModel.saveNotificationSetting(newValue) // 토글 상태를 저장
                }
                
                // 알림이 켜져 있을 때만 간격 선택 가능
                Stepper("간격: \(pushSettingViewModel.interval / 3600, specifier: "%.0f") 시간", value: $pushSettingViewModel.interval, in: 3600...(24 * 3600), step: 3600)
                    .padding()
                    .disabled(!pushSettingViewModel.isNotificationEnabled) // 알림 꺼져 있으면 비활성화

                // 알림 설정 버튼
                Button(action: {
                    if pushSettingViewModel.isNotificationEnabled {
                        pushSettingViewModel.scheduleRandomNotification(with: motivationViewModel.motivations)
                    } else {
                        pushSettingViewModel.clearExistingNotifications()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("알림 설정")
                        .padding()
                        .background(pushSettingViewModel.isNotificationEnabled ? CustomColor.SwiftUI.customGreen : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(!pushSettingViewModel.isNotificationEnabled) // 알림이 꺼져 있으면 버튼도 비활성화
                
                Spacer()
                
                .alert(isPresented: $pushSettingViewModel.isNotificationScheduled) {
                    Alert(title: Text("예약 완료!"), message: Text("알림이 예약되었습니다."), dismissButton: .default(Text("확인")))
                }
            }
            .background(CustomColor.SwiftUI.customBackgrond)
            .onAppear {
                // 알림 설정 상태 로드
                pushSettingViewModel.loadSettings()
                motivationViewModel.loadMotivations()
            }
        }
        .navigationBarHidden(true)
    }
}


struct PushSettingHeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Text("알림 간격 설정")
                .foregroundColor(CustomColor.SwiftUI.customGreen)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer() // 제목을 왼쪽에 고정
            
            //            Button(action: {
            //                presentationMode.wrappedValue.dismiss()
            //                print("뒤로가기 클릭")
            //            }) {
            //                HStack {
            //                    Text("Back")
            //                        .foregroundColor(CustomColor.SwiftUI.customGreen)
            //                    Image(systemName: "chevron.right")
            //                        .foregroundColor(CustomColor.SwiftUI.customGreen)
            //                }
            //            }
            //            .padding(.trailing)
        }
        .background(CustomColor.SwiftUI.customBackgrond)
    }
}

#Preview {
    PushSettingHeaderView()
}


#Preview {
    PushSettingView()
}
