//
//  PushSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import SwiftUI
import CoreData

struct PushSettingView: View {
    @StateObject private var viewModel: PushSettingViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTime: Date = Date() // 선택된 시간 저장

    init() {
        _viewModel = StateObject(wrappedValue: PushSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting")))
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.alarmSettings, id: \.id) { alarm in
                        HStack {
                            Text("\(alarm.time ?? Date(), formatter: DateFormatter.shortTime)")
                                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                            Toggle("Enabled", isOn: Binding(
                                get: { alarm.isEnabled },
                                set: { newValue in
                                    alarm.isEnabled = newValue // Core Data에서 알람 업데이트
                                    viewModel.saveContext() // 저장
                                }
                            ))
                        }
                    }
                    .onDelete(perform: deleteAlarms)
                }

                // DatePicker 추가
                DatePicker("Select Alarm Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()

                Button("Add Alarm") {
                    viewModel.createAlarm(time: selectedTime, isEnabled: true, isRepeated: false) // 알람 추가
                }
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .padding()
            }
            .navigationTitle("Alarm Settings")
            .onAppear {
                viewModel.fetchAlarmSettings() // 알람 설정 불러오기
            }
        }
    }

    private func deleteAlarms(at offsets: IndexSet) {
        for index in offsets {
            let alarm = viewModel.alarmSettings[index]
            viewModel.deleteAlarmSetting(alarm: alarm) // 알람 삭제
        }
    }
}

extension DateFormatter {
    static var shortTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
}

//struct PushSettingView: View {
//    @StateObject private var motivationViewModel = MotivationViewModel()
//    @StateObject private var pushSettingViewModel: PushSettingViewModel
//    
//    init() {
//        let motivationViewModel = MotivationViewModel()
//        _pushSettingViewModel = StateObject(wrappedValue: PushSettingViewModel(motivationViewModel: motivationViewModel))
//    }
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                CustomHeaderView(title: "알림 간격 설정") {
//                    EmptyView()
//                }
//                
//                // 알림 활성화/비활성화 토글
//                Toggle(isOn: $pushSettingViewModel.isNotificationEnabled) {
//                    Text(pushSettingViewModel.isNotificationEnabled ? "알림 켜짐" : "알림 꺼짐")
//                        .font(.headline)
//                        .foregroundColor(pushSettingViewModel.isNotificationEnabled ? .green : .red)
//                }
//                .padding()
//                .onChange(of: pushSettingViewModel.isNotificationEnabled) { newValue in
//                    pushSettingViewModel.saveNotificationSetting(newValue)
//                }
//                
//                // 알림 간격 설정 스텝퍼
//                Stepper("간격: \(pushSettingViewModel.interval / 3600, specifier: "%.0f") 시간", value: $pushSettingViewModel.interval, in: 3600...7200, step: 3600)
//                    .padding()
//                    .disabled(!pushSettingViewModel.isNotificationEnabled) // 알림이 비활성화 상태일 때 비활성화
//                
//                // 알림 설정 버튼
//                Button(action: {
//                    if pushSettingViewModel.isNotificationEnabled {
//                        pushSettingViewModel.scheduleRandomNotification() // 랜덤 알림 예약
//                    } else {
//                        pushSettingViewModel.clearExistingNotifications() // 기존 알림 삭제
//                    }
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("알림 설정")
//                        .padding()
//                        .background(pushSettingViewModel.isNotificationEnabled ? CustomColor.SwiftUI.customGreen : Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//                .disabled(!pushSettingViewModel.isNotificationEnabled) // 알림이 비활성화 상태일 때 비활성화
//                
//                Spacer()
//                
//                // 알림 예약 완료 알림
//                .alert(isPresented: $pushSettingViewModel.isNotificationScheduled) {
//                    Alert(title: Text("예약 완료!"), message: Text("알림이 예약되었습니다."), dismissButton: .default(Text("확인")))
//                }
//            }
//            .background(CustomColor.SwiftUI.customBackgrond)
//            .onAppear {
//                // 알림 설정 상태 및 모티베이션 로드
//                pushSettingViewModel.loadSettings()
//                motivationViewModel.loadMotivations()
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}

//#Preview {
//    PushSettingView(context: <#NSManagedObjectContext#>)
//}
