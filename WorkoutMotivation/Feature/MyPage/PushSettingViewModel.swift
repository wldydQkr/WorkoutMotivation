//
//  PushSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import Foundation
import UserNotifications

final class PushSettingViewModel: ObservableObject {
    @Published var selectedTime: Date = Date()
    @Published var interval: TimeInterval = 3600 // 기본 1시간
    @Published var isNotificationEnabled: Bool = false
    @Published var isNotificationScheduled: Bool = false
    
    // 초기 설정값 저장
    private var initialNotificationEnabled: Bool = false
    private var initialInterval: TimeInterval = 3600
    
    init() {
        loadSettings()
        requestNotificationPermission()
    }
    
    // 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
                } else {
                    self.isNotificationEnabled = granted && self.loadNotificationSetting()
                    // 초기 상태 저장
                    self.initialNotificationEnabled = self.isNotificationEnabled
                    self.initialInterval = self.interval
                }
            }
        }
    }
    
    // 알림 설정을 저장
    func saveNotificationSetting(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "isNotificationEnabled")
    }
    
    // 저장된 알림 설정을 불러옴
    func loadNotificationSetting() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNotificationEnabled")
    }
    
    // 알림 상태 및 기타 설정을 불러옴
    func loadSettings() {
        isNotificationEnabled = loadNotificationSetting()
        // 초기 상태 저장
        initialNotificationEnabled = isNotificationEnabled
        initialInterval = interval
    }
    
    // 기존 상태와 현재 상태 비교
    func hasSettingsChanged() -> Bool {
        return isNotificationEnabled != initialNotificationEnabled || interval != initialInterval
    }
    
    // 푸시 알림 예약
    func scheduleRandomNotification(with motivations: [Motivation]) {
        guard isNotificationEnabled else {
            print("알림 권한이 없습니다.")
            return
        }
        
        guard !motivations.isEmpty else {
            print("모티베이션 목록이 비어 있습니다.")
            return
        }
        
        clearExistingNotifications() // 기존 알림을 먼저 삭제
        
        let randomMotivation = motivations.randomElement()!
        
        let content = UNMutableNotificationContent()
        content.title = "WorkoutMotivation"
        content.body = "\(randomMotivation.title) \n- \(randomMotivation.name)"
        content.sound = .default
        
        // 알림 트리거: 반복하지 않고 한 번만 실행되도록 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 예약 중 오류 발생: \(error.localizedDescription)")
                } else {
                    self.isNotificationScheduled = true
                    print("알림이 예약되었습니다. \(self.interval)초 후에 실행됩니다.")
                    
                    // 알림이 실행된 후 새로운 알림 예약 (다음 알림 예약)
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) {
                        self.scheduleRandomNotification(with: motivations)
                    }
                }
            }
        }
    }
    
    // 기존 알림 삭제
    func clearExistingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
    
//    func scheduleRandomNotification(with motivations: [Motivation]) {
//        guard isNotificationEnabled else {
//            print("알림 권한이 없습니다.")
//            return
//        }
//        
//        guard motivations.count >= 2 else {
//            print("모티베이션 목록이 2개 이상이어야 합니다.")
//            return
//        }
//        
//        // 기존 알림 제거
//        clearExistingNotifications()
//        
//        // 두 개의 겹치지 않는 랜덤 모티베이션 선택
//        var firstMotivation = motivations.randomElement()!
//        var secondMotivation = motivations.randomElement()!
//        
//        // 두 값이 같다면 다시 랜덤 선택
//        while firstMotivation.title == secondMotivation.name {
//            secondMotivation = motivations.randomElement()!
//        }
//        
//        let content = UNMutableNotificationContent()
//        content.title = "WorkoutMotivation"
//        content.body = "\(firstMotivation.title) \n- \(secondMotivation.name)"  // 겹치지 않는 title과 name을 사용
//        content.sound = .default
//        
//        // 선택한 간격으로 반복되는 알림 예약
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
//        
//        let requestIdentifier = UUID().uuidString
//        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("알림 예약 중 오류 발생: \(error.localizedDescription)")
//                } else {
//                    self.isNotificationScheduled = true
//                    self.notificationIdentifiers.append(requestIdentifier) // 예약된 알림의 ID 저장
//                    print("알림이 \(self.interval / 3600)시간 간격으로 예약되었습니다.")
//                }
//            }
//        }
//    }
