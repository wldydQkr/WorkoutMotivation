//
//  PushSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/27/24.
//

import Foundation
import CoreData
import UserNotifications

final class PushSettingViewModel: ObservableObject {
    @Published var alarmSettings: [AlarmSettingEntity] = []
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext(for: "AlarmSetting")) {
        self.context = context
        fetchAlarmSettings() // 초기 데이터 불러오기
    }

    func fetchAlarmSettings() {
        let request: NSFetchRequest<AlarmSettingEntity> = AlarmSettingEntity.fetchRequest()
        do {
            alarmSettings = try context.fetch(request)
            print("Fetched alarms: \(alarmSettings.count)")
        } catch {
            print("Failed to fetch alarm settings: \(error)")
        }
    }

    func createAlarm(time: Date, isEnabled: Bool, isRepeated: Bool) {
        let newAlarm = AlarmSettingEntity(context: context)
        newAlarm.id = UUID()
        newAlarm.time = time
        newAlarm.isEnabled = isEnabled
        newAlarm.isRepeated = isRepeated

        scheduleNotification(for: newAlarm) // 푸시 알림 등록
        saveContext() // CoreData 저장
        fetchAlarmSettings() // 알람 목록 갱신
    }

    func scheduleNotification(for alarm: AlarmSettingEntity) {
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "랜덤 동기부여 메시지: \(getRandomMotivationMessage())" // 랜덤 메시지 가져오기
        content.sound = .default
        
        // 알람 시간 설정
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: alarm.time ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: alarm.isRepeated)

        // 요청 식별자
        let request = UNNotificationRequest(identifier: alarm.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func getRandomMotivationMessage() -> String {
        // 랜덤으로 동기부여 메시지를 가져오는 로직 추가
        // MotivationViewModel을 통해 메시지를 가져오는 코드 작성
        let motivationViewModel = MotivationViewModel() // 새로운 인스턴스 생성 (이곳에서 데이터를 가져올 수 있음)
        if let randomMotivation = motivationViewModel.getRandomMotivation() {
            return randomMotivation.title // 메시지로 제목을 사용
        }
        return "시간이 되어 알림이 도착했습니다!" // 기본 메시지
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully.")
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }

    func deleteAlarmSetting(alarm: AlarmSettingEntity) {
        context.delete(alarm)
        saveContext()
        fetchAlarmSettings()
    }
}

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
