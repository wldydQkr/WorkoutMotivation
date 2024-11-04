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
        loadNotifications()
        loadLikedMotivations()
    }
    
    func addNotification() {
        guard notifications.count < 12 else {
            showAlert = true
            return
        }
        
        let newNotification = NotificationItem(date: Date(), motivation: likedMotivations.first)
        notifications.append(newNotification)
    }
    
    func showDeleteConfirmation(for index: Int) {
        indexToDelete = index
        showDeleteAlert = true
    }
    
    func confirmDelete() {
        if let index = indexToDelete {
            let item = notifications[index]
            cancelNotification(for: item) // 삭제할 알림을 먼저 취소
            notifications.remove(at: index)
            indexToDelete = nil
        }
    }
    
    func updateNotification(for item: NotificationItem) {
        cancelNotification(for: item)
        scheduleNotification(for: item)
    }
    
    func rescheduleNotification(for item: NotificationItem, with motivation: Motivation) {
        cancelNotification(for: item)
        var updatedItem = item
        updatedItem.motivation = motivation
        scheduleNotification(for: updatedItem)
    }
    
    private func cancelNotification(for item: NotificationItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }

    private func scheduleNotification(for item: NotificationItem) {
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

struct NotificationItem: Codable {
    var id = UUID()
    var date: Date
    var motivation: Motivation?
    var repeats: Bool = false
}
