//
//  PushSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import SwiftUI
import CoreData

struct PushSettingView: View {
    @StateObject private var viewModel: PushSettingViewModel = PushSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"))
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showDatePicker: Bool = false // DatePicker 플로팅을 제어하는 상태 변수
    @State private var selectedTime: Date = Date() // 선택된 시간 저장

    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "알림 설정") {
                    Button(action: {
                        withAnimation(.easeInOut) { // 애니메이션 추가
                            showDatePicker.toggle() // 플러스 버튼을 누르면 DatePicker 플로팅
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                
                List {
                    ForEach(viewModel.alarmSettings, id: \.id) { alarm in
                        if let alarmSetting = alarm as? AlarmSettingEntity {
                            HStack {
                                Text("\(alarmSetting.time ?? Date(), formatter: DateFormatter.shortTime)")
                                    .foregroundColor(.black)

                                Toggle(alarmSetting.isEnabled ? "활성" : "해제", isOn: Binding<Bool>(
                                    get: { alarmSetting.isEnabled },
                                    set: { newValue in
                                        alarmSetting.isEnabled = newValue
                                        viewModel.saveAlarmSetting(alarm: alarmSetting)
                                        if newValue {
                                            viewModel.scheduleNotification(for: alarmSetting)
                                        } else {
                                            viewModel.cancelNotification(for: alarmSetting)
                                        }
                                    }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: CustomColor.SwiftUI.customBlack)) // 스위치 스타일 설정
                            }
                        }
                    }
                    .onDelete(perform: deleteAlarms)
                }
                .background(CustomColor.SwiftUI.customBackgrond)
                .listStyle(.plain)
                .scrollIndicators(.hidden)

                // 플로팅 형식의 DatePicker를 모달 형식으로 구현
                if showDatePicker {
                    DatePickerFloatingView(
                        selectedTime: $selectedTime,
                        onSave: {
                            viewModel.createAlarm(time: selectedTime) // 알람 추가
                            withAnimation(.easeInOut) { // 사라지는 애니메이션
                                showDatePicker = false
                            }
                        },
                        onCancel: {
                            withAnimation(.easeInOut) { // 사라지는 애니메이션
                                showDatePicker = false
                            }
                        }
                    )
                    .transition(.move(edge: .bottom)) // 아래에서 위로 올라오는 애니메이션
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadAlarmSettings()
            }
        }
        .navigationBarHidden(true)
    }

    private func deleteAlarms(at offsets: IndexSet) {
        for index in offsets {
            let alarm = viewModel.alarmSettings[index]
            viewModel.deleteAlarmSetting(alarm: alarm)
        }
    }
}

// DatePicker를 플로팅 형식으로 분리한 뷰
struct DatePickerFloatingView: View {
    @Binding var selectedTime: Date
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Text("알림 시간 설정")
                    .padding(.top, 20)
                    .font(.headline)

                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()

                HStack {
                    Button(action: onCancel) {
                        Text("취소")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: onSave) {
                        Text("저장")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.9))) // 배경 투명도 설정
            .shadow(radius: 20)
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
        .background(Color.clear.opacity(0.0))
    }
}

extension DateFormatter {
    static var shortTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
}

//#Preview {
//    PushSettingView(context: <#NSManagedObjectContext#>)
//}
