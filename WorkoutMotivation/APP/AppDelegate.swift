//
//  AppDelegate.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import UIKit
import BackgroundTasks
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    var pushSettingViewModel: PushSettingViewModel!
    var motivationViewModel = MotivationViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
//        UNUserNotificationCenter.current().delegate = self
        
        // 알림 권한 요청
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // 권한이 부여된 경우 처리
        }
        
        // PushSettingViewModel 초기화
        pushSettingViewModel = PushSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"))
        
        return true
    }
    
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotification) {
//        let viewModel = NotificationSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"), motivationViewModel: motivationViewModel)
//        viewModel.scheduleNotification(for: notification)
//    }
//}
