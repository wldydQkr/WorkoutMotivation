//
//  PushSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import SwiftUI
import CoreData

struct PushSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PushSettingViewModel = PushSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"))
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showDatePicker: Bool = false
    @State private var selectedTime: Date = Date()

    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "알림 설정") {
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showDatePicker.toggle()
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 10)
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                            Text("back")
                        }
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
                                            viewModel.scheduleRandomNotification()
                                        } else {
                                            viewModel.cancelNotification(for: alarmSetting)
                                        }
                                    }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: CustomColor.SwiftUI.customBlack))
                            }
                        }
                    }
                    .onDelete(perform: deleteAlarms)
                }
                .background(CustomColor.SwiftUI.customBackgrond)
                .listStyle(.plain)
                .scrollIndicators(.hidden)

                if showDatePicker {
                    DatePickerFloatingView(
                        selectedTime: $selectedTime,
                        onSave: {
                            viewModel.createAlarm(time: selectedTime)
                            withAnimation(.easeInOut) {
                                showDatePicker = false
                            }
                        },
                        onCancel: {
                            withAnimation(.easeInOut) {
                                showDatePicker = false
                            }
                        }
                    )
                    .transition(.move(edge: .bottom))
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
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.9)))
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
