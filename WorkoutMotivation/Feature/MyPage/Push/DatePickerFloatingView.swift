//
//  DatePickerFloatingView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/1/24.
//

import SwiftUI

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
