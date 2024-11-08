//
//  NotificationSettingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/31/24.
//

import Foundation
import UserNotifications
import Combine

final class NotificationSettingViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = [] {
        didSet {
            saveNotifications()
        }
    }
    @Published var showAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var likedMotivations: [Motivation] = []
    
    private var indexToDelete: Int?
    private let userDefaultsKey = "notifications"
    private var subscriptions = Set<AnyCancellable>()

    init() {
        loadNotifications() // 같이 좋아요한 명언 업데이트 될 수 있도록 업데이트 할거임
        loadLikedMotivations()
    }
    
    // 푸시 추가
    func addNotification() {
        guard notifications.count < 12 else {
            showAlert = true
            return
        }
        
        let newNotification = NotificationItem(date: Date(), motivation: likedMotivations.first, repeats: true)
        notifications.append(newNotification)
    }
    
    // 삭제 알럿 표시
    func showDeleteConfirmation(for index: Int) {
        indexToDelete = index
        showDeleteAlert = true
    }
    
    // 푸시 취소
    func confirmDelete() {
        if let index = indexToDelete {
            let item = notifications[index]
            cancelNotification(for: item) // 삭제할 알림을 먼저 취소
            notifications.remove(at: index)
            indexToDelete = nil
        }
    }
    
    // 푸시 업데이트
    func updateNotification(for item: NotificationItem) {
        cancelNotification(for: item)
        if item.repeats {
            scheduleNotification(for: item)
        }
    }
    
    // 푸시 재예약
    func rescheduleNotification(for item: NotificationItem, with motivation: Motivation) {
        cancelNotification(for: item)
        var updatedItem = item
        updatedItem.motivation = motivation
        scheduleNotification(for: updatedItem)
    }
    
    // 푸시 취소
    private func cancelNotification(for item: NotificationItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
        print("알림이 취소되었습니다.")
    }

    private func scheduleNotification(for item: NotificationItem) {
        guard item.repeats else { return } // 반복 토글이 활성화 되어 있지 않으면 알림 예약 x
        
        let content = UNMutableNotificationContent()
        content.title = "WorkoutMotivation"
        content.body = "\(item.motivation?.title ?? "알림")\n-\(item.motivation?.name ?? "내용 없음")"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: item.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: item.repeats)

        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 예약 오류: \(error.localizedDescription)")
            }
            print("알림 예약 완료.")
        }
    }
    
    func scheduleNotifications() {
        for notification in notifications {
            scheduleNotification(for: notification)
        }
    }
    
    private func loadLikedMotivations() {
        if let savedLikes = UserDefaults.standard.array(forKey: "likedMotivations") as? [Int] {
            likedMotivations = savedLikes.compactMap { id in
                MotivationViewModel.shared.motivations.first(where: { $0.id == id })
            }
        }
    }
    
    private func saveNotifications() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadNotifications() {
        let decoder = JSONDecoder()
        if let savedNotificationsData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decodedNotifications = try? decoder.decode([NotificationItem].self, from: savedNotificationsData) {
                notifications = decodedNotifications
            }
        }
    }
    
    func reloadLikedMotivations() {
        loadLikedMotivations()
    }
}
