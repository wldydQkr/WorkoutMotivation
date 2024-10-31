//
//  PushSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import Foundation
import UserNotifications
import CoreData
import FirebaseDatabase
import FirebaseMessaging

final class PushSettingViewModel: ObservableObject {
    @Published var alarmSettings: [AlarmSettingEntity] = []
    private var context: NSManagedObjectContext
    private let databaseRef = Database.database().reference()
    private var userToken: String?

    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext(for: "AlarmSetting")) {
        self.context = context
        loadAlarmSettings()
        requestNotificationAuthorization()
        
        // FCM 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error)")
            } else if let token = token {
                self.userToken = token
                print("FCM 토큰: \(token)")
            }
        }
    }
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error)")
            }
        }
    }

    func createAlarm(time: Date, isEnabled: Bool = true) {
        let newAlarm = AlarmSettingEntity(context: context)
        newAlarm.id = UUID()
        newAlarm.time = time
        newAlarm.isEnabled = isEnabled
        saveContext()
        loadAlarmSettings()
    }
    
    func loadAlarmSettings() {
        let request: NSFetchRequest<AlarmSettingEntity> = AlarmSettingEntity.fetchRequest()
        do {
            alarmSettings = try context.fetch(request)
        } catch {
            print("알람 설정 로드 실패: \(error)")
        }
    }
    
    func saveAlarmSetting(alarm: AlarmSettingEntity) {
        DispatchQueue.main.async {
            self.saveContext()
            self.loadAlarmSettings()
        }
    }
    
    func deleteAlarmSetting(alarm: AlarmSettingEntity) {
        context.delete(alarm)
        saveContext()
        loadAlarmSettings()
    }

    func scheduleRandomNotification() {
        databaseRef.child("motivations").observeSingleEvent(of: .value) { snapshot in
            guard let motivations = snapshot.value as? [String: [String: String]] else { return }
            let randomMotivation = self.getRandomMotivation(from: motivations)
            
            let content = UNMutableNotificationContent()
            content.title = "WorkoutMotivation"
            content.body = "\(randomMotivation["title"] ?? "") - \(randomMotivation["name"] ?? "")"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 추가 실패: \(error)")
                } else {
                    print("알림 예약 성공: \(content.body)")
                }
            }
        }
    }

    func cancelNotification(for alarm: AlarmSettingEntity) {
        if let id = alarm.id?.uuidString {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
    
    private func getRandomMotivation(from motivations: [String: [String: String]]) -> [String: String] {
        let keys = Array(motivations.keys)
        guard let randomKey = keys.randomElement(), let randomMotivation = motivations[randomKey] else {
            return ["title": "Stay Strong", "name": "Your Coach"]
        }
        return randomMotivation
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("컨텍스트 저장 실패: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: 백그라운드 처리 로직
//final class PushSettingViewModel: ObservableObject {
//    @Published var interval: TimeInterval = 3600 // 기본 1시간
//    @Published var isNotificationEnabled: Bool = false // 기본값은 false로 설정
//    @Published var isNotificationScheduled: Bool = false
//    
//    private var motivationViewModel: MotivationViewModel // MotivationViewModel 참조 추가
//    
//    init(motivationViewModel: MotivationViewModel) { // 초기화 시 MotivationViewModel 주입
//        self.motivationViewModel = motivationViewModel
//        loadSettings() // 앱 실행 시 저장된 알림 설정을 불러옴
//        requestNotificationPermission()
//    }
//    
//    // 알림 권한 요청
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
//                } else {
//                    self.isNotificationEnabled = granted && self.loadNotificationSetting() // 저장된 알림 설정을 반영
//                }
//            }
//        }
//    }
//    
//    // 알림 설정을 저장
//    func saveNotificationSetting(_ isEnabled: Bool) {
//        UserDefaults.standard.set(isEnabled, forKey: "isNotificationEnabled")
//    }
//    
//    // 저장된 알림 설정을 불러옴
//    func loadNotificationSetting() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isNotificationEnabled")
//    }
//    
//    // 알림 상태 및 기타 설정을 불러옴
//    func loadSettings() {
//        isNotificationEnabled = loadNotificationSetting() // 알림 활성화 상태 불러오기
//    }
//    
//    // 백그라운드 작업 예약 함수 (AppDelegate에서 호출되는 것과 동일)
//    func scheduleNextBackgroundTask() {
//        let request = BGProcessingTaskRequest(identifier: "co.kr.jiyongppark.WorkoutMotivation.notification")
//        request.requiresNetworkConnectivity = false // 네트워크 필요 없음
//
//        // PushSettingViewModel의 interval 값을 사용하여 예약 시간 설정
//        request.earliestBeginDate = Date(timeIntervalSinceNow: interval)
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("백그라운드 작업 예약 실패: \(error)")
//        }
//    }
//    
//    // 랜덤 알림 예약
//    func scheduleRandomNotification() {
//        guard isNotificationEnabled else {
//            print("알림 권한이 없습니다.")
//            return
//        }
//
//        guard !motivationViewModel.motivations.isEmpty else {
//            print("모티베이션 목록이 비어 있습니다.")
//            return
//        }
//
//        let randomMotivation = motivationViewModel.motivations.randomElement()!
//
//        let content = UNMutableNotificationContent()
//        content.title = "WorkoutMotivation"
//        content.body = "\(randomMotivation.title) \n- \(randomMotivation.name)"
//        content.sound = .default
//
//        // 설정된 간격을 사용
//        let notificationInterval = interval // 현재 interval 값을 사용
//
//        // 알림 트리거 설정
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationInterval, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("알림 예약 중 오류 발생: \(error.localizedDescription)")
//                } else {
//                    self.isNotificationScheduled = true
//                    print("알림이 예약되었습니다.")
//                    
//                    // 다음 백그라운드 작업 예약
//                    self.scheduleNextBackgroundTask()  // 알림을 받을 때마다 다음 알림 예약
//                }
//            }
//        }
//    }
//    
//    // 기존 알림 삭제
//    func clearExistingNotifications() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//    
//    // 알림 설정 변경 확인
//    func hasSettingsChanged() -> Bool {
//        let savedSetting = loadNotificationSetting()
//        return savedSetting != isNotificationEnabled || (interval != 3600)
//    }
//}
    
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
