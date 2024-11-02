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
    @Published var showDeleteAlert: Bool = false // 삭제 확인 알럿 표시 여부
    @Published var likedMotivations: [Motivation] = [] // 좋아요한 명언 리스트
    private var indexToDelete: Int? // 삭제할 알림의 인덱스
    
    private let userDefaultsKey = "notifications"
    private var subscriptions = Set<AnyCancellable>() // Combine 구독 저장

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
        showDeleteAlert = true // 삭제 알럿 표시
    }
    
    func confirmDelete() {
        if let index = indexToDelete {
            notifications.remove(at: index)
            indexToDelete = nil
        }
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
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
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
        loadLikedMotivations() // 좋아요한 명언 리스트 업데이트
    }
    
}

struct NotificationItem: Codable {
    var date: Date
    var motivation: Motivation?
    var repeats: Bool = false
}
