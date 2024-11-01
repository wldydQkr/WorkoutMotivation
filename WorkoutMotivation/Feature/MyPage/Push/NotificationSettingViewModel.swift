//
//  NotificationSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import Foundation
import UserNotifications

final class NotificationSettingViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var showAlert: Bool = false // 알림 추가 불가 시 알림 표시
    
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
            content.body = "\(notification.motivation?.title ?? "알림") -\(notification.motivation?.name ?? "내용 없음")"
            content.sound = .default
            
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notification.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("알림 예약 오류: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct NotificationItem {
    var date: Date
    var motivation: Motivation?
}
