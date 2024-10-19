//
//  PushSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import Foundation
import UserNotifications
import BackgroundTasks

final class PushSettingViewModel: ObservableObject {
    @Published var selectedTime: Date = Date()
    @Published var interval: TimeInterval = 3600 // 기본 1시간
    @Published var isNotificationEnabled: Bool = false // 기본값은 false로 설정
    @Published var isNotificationScheduled: Bool = false
    
    private var motivationViewModel: MotivationViewModel // MotivationViewModel 참조 추가
    
    init(motivationViewModel: MotivationViewModel) { // 초기화 시 MotivationViewModel 주입
        self.motivationViewModel = motivationViewModel
        loadSettings() // 앱 실행 시 저장된 알림 설정을 불러옴
        requestNotificationPermission()
    }
    
    // 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
                } else {
                    self.isNotificationEnabled = granted && self.loadNotificationSetting() // 저장된 알림 설정을 반영
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
        isNotificationEnabled = loadNotificationSetting() // 알림 활성화 상태 불러오기
    }
    
    // 백그라운드 작업 예약 함수 (AppDelegate에서 호출되는 것과 동일)
    func scheduleNextBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "co.kr.jiyongppark.WorkoutMotivation.notification")
        request.requiresNetworkConnectivity = false // 네트워크 필요 없음

        // PushSettingViewModel의 interval 값을 사용하여 예약 시간 설정
        let intervalInSeconds = self.interval
        request.earliestBeginDate = Date(timeIntervalSinceNow: intervalInSeconds)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("백그라운드 작업 예약 실패: \(error)")
        }
    }
    
    // 랜덤 알림 예약
    func scheduleRandomNotification() {
        guard isNotificationEnabled else {
            print("알림 권한이 없습니다.")
            return
        }

        guard !motivationViewModel.motivations.isEmpty else {
            print("모티베이션 목록이 비어 있습니다.")
            return
        }

        let randomMotivation = motivationViewModel.motivations.randomElement()!

        let content = UNMutableNotificationContent()
        content.title = "WorkoutMotivation"
        content.body = "\(randomMotivation.title) \n- \(randomMotivation.name)"
        content.sound = .default

        // 알림 트리거 설정 (선택한 시간 간격)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false) // repeats: false로 수정

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 예약 중 오류 발생: \(error.localizedDescription)")
                } else {
                    self.isNotificationScheduled = true
                    print("알림이 예약되었습니다.")
                    
                    // 다음 백그라운드 작업 예약
                    self.scheduleNextBackgroundTask()  // 알림을 받을 때마다 다음 알림 예약
                }
            }
        }
    }
    
    // 기존 알림 삭제
    func clearExistingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 백그라운드 작업 실행 시 알림 예약
    func scheduleNextNotification() {
        // 1. 기존 알림 삭제
        clearExistingNotifications()

        // 2. 새로운 알림 예약
        scheduleRandomNotification()
    }

    // 알림 설정 변경 확인
    func hasSettingsChanged() -> Bool {
        let savedSetting = loadNotificationSetting()
        return savedSetting != isNotificationEnabled || (interval != 3600)
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
