//
//  NotificationService.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import UserNotifications

struct NotificationService {
  func sendNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
      if granted {
        let content = UNMutableNotificationContent()
        content.title = "세트 간 휴식 끝!"
        content.body = "세트 간 휴식 시간이 끝났습니다."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
          identifier: UUID().uuidString,
          content: content,
          trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
      }
    }
  }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .sound])
  }
}
