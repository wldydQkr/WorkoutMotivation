//
//  NotificationSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import Foundation
import UserNotifications

final class NotificationSettingViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = [] {
        didSet {
            saveNotifications() // notifications가 변경될 때마다 저장
        }
    }
    @Published var showAlert: Bool = false // 알림 추가 불가 시 알림 표시

    private let userDefaultsKey = "notifications"

    init() {
        loadNotifications() // 초기 로드
    }
    
    func addNotification() {
        guard notifications.count < 12 else {
            showAlert = true // 최대 개수 초과 시 알림 표시
            return
        }
        
        let newNotification = NotificationItem(date: Date(), motivation: MotivationViewModel.shared.getRandomMotivation())
        notifications.append(newNotification)
    }
    
    func removeNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
    
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = "WorkoutMotivation"
            content.body = "\(notification.motivation?.title ?? "알림")\n-\(notification.motivation?.name ?? "내용 없음")"
            content.sound = .default
            
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notification.date)
            let trigger: UNNotificationTrigger
            
            if notification.repeats {
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true) // 하루마다 반복
            } else {
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            }
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("알림 예약 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // UserDefaults에 notifications 저장
    private func saveNotifications() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // UserDefaults에서 notifications 로드
    private func loadNotifications() {
        let decoder = JSONDecoder()
        if let savedNotificationsData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decodedNotifications = try? decoder.decode([NotificationItem].self, from: savedNotificationsData) {
                notifications = decodedNotifications
            }
        }
    }
}

struct NotificationItem: Codable {
    var date: Date
    var motivation: Motivation?
    var repeats: Bool = false
}
