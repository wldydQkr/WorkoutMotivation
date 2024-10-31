//
//  NotificationSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import Foundation
import UserNotifications
import CoreData

final class NotificationSettingViewModel: ObservableObject {
    @Published var alarmSettings: [AlarmSettingEntity] = []
    private var context: NSManagedObjectContext
    private let motivationViewModel: MotivationViewModel
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext(for: "AlarmSetting"), motivationViewModel: MotivationViewModel) {
        self.context = context
        self.motivationViewModel = motivationViewModel
    }

    // 알림 설정 로드
    func loadAlarmSettings() {
        let fetchRequest: NSFetchRequest<AlarmSettingEntity> = AlarmSettingEntity.fetchRequest()
        do {
            alarmSettings = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch alarm settings: \(error)")
        }
    }

    // 알림 예약
    func scheduleNotification(for alarmSetting: AlarmSettingEntity) {
        let content = UNMutableNotificationContent()
        content.title = "WorkoutMotivation"
        content.body = "\(motivationViewModel.getRandomMotivation()?.title ?? "기본 제목") -\(motivationViewModel.getRandomMotivation()?.name ?? "기본 내용")"
        content.sound = .default
        
        // 알림 시간 설정
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: alarmSetting.time ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }

    // 알림 수신 시 자동 재예약 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotification) {
        // 알림 제목이나 내용을 기반으로 알람 설정을 찾습니다.
        let notificationTitle = notification.request.content.title
        let notificationBody = notification.request.content.body

        // 알림 설정 찾기
        guard let alarmSetting = alarmSettings.first(where: {
            $0.isEnabled && $0.title == notificationTitle && $0.body == notificationBody
        }) else {
            return
        }

        // 알림 재예약
        scheduleNotification(for: alarmSetting)
    }

    // 특정 알림 설정 삭제
    func deleteAlarmSetting(alarm: AlarmSettingEntity) {
        context.delete(alarm)
        saveContext()
    }

    // 알림 설정 저장
    func saveAlarmSetting(alarm: AlarmSettingEntity) {
        saveContext()
    }

    // 컨텍스트 저장
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
