//
//  NotificationSettingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import SwiftUI

struct NotificationSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NotificationSettingViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showDatePicker: Bool = false
    @State private var selectedTime: Date = Date()
    
    init() {
        let motivationViewModel = MotivationViewModel()
        _viewModel = StateObject(wrappedValue: NotificationSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"), motivationViewModel: motivationViewModel))
    }

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
                                            viewModel.scheduleNotification(for: alarmSetting)
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

#Preview {
    NotificationSettingView()
}
