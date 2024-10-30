//
//  AppDelegate.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import UIKit
import BackgroundTasks
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    var pushSettingViewModel: PushSettingViewModel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = notificationDelegate
        pushSettingViewModel = PushSettingViewModel()
        notificationDelegate.pushSettingViewModel = pushSettingViewModel
        
        
        
        // PushSettingViewModel 초기화
        pushSettingViewModel = PushSettingViewModel(context: PersistenceController.shared.viewContext(for: "AlarmSetting"))
        
        return true
    }
    
    
    // 앱이 포그라운드에 있을 때 알림이 오면 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // 사용자가 알림을 탭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 수신된 특정 알림 ID로 알림을 재예약
        if let alarmID = UUID(uuidString: response.notification.request.identifier) {
            pushSettingViewModel.reloadSingleAlarm(alarmID: alarmID)
        }
        
        completionHandler()
        
        print("didReceive")
    }
    
    
    // 백그라운드에서 조용히 수신된 원격 알림 처리
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 알림 재예약 로직
        pushSettingViewModel.loadAlarmSettings()
        // 각 알람을 재예약
        for alarm in pushSettingViewModel.alarmSettings where alarm.isEnabled {
            pushSettingViewModel.scheduleNotification(for: alarm)
            print("didRecieveRemoteNotification")
        }
        completionHandler(.newData)
    }
}

extension PushSettingViewModel {
    func reloadSingleAlarm(alarmID: UUID) {
        // 해당 알림이 존재하는지 확인하고, 새로운 푸시 알림 예약
        if let alarm = alarmSettings.first(where: { $0.id == alarmID }) {
            cancelNotification(for: alarm)
            scheduleNotification(for: alarm)
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    weak var pushSettingViewModel: PushSettingViewModel?

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let alarmID = UUID(uuidString: response.notification.request.identifier) {
            pushSettingViewModel?.reloadSingleAlarm(alarmID: alarmID)
        }
        completionHandler()
    }
}
