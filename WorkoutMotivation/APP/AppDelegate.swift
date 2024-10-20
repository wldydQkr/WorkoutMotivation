//
//  AppDelegate.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    var pushSettingViewModel: PushSettingViewModel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        pushSettingViewModel = PushSettingViewModel(motivationViewModel: MotivationViewModel())
        
//        // Background task 등록
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "notification", using: nil) { task in
//            // Background 작업을 실행
//            self.handleBackgroundTask(task: task as! BGProcessingTask)
//        }
//        
//        // 백그라운드 작업 예약
//        scheduleNextBackgroundTask()
        
        return true
    }
    
    // 백그라운드 작업 처리 함수
    func handleBackgroundTask(task: BGProcessingTask) {
        pushSettingViewModel.scheduleNextNotification() // 알림 예약 메서드 호출
        
        // 작업이 완료되었음을 시스템에 알림
        task.setTaskCompleted(success: true)
        
        // 다음 백그라운드 작업 예약
        scheduleNextBackgroundTask()
    }
    
    // 백그라운드 작업을 예약하는 함수
    func scheduleNextBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "notification")
        request.requiresNetworkConnectivity = false // 네트워크 필요 없음
        
        // PushSettingViewModel의 interval 값을 사용하여 예약 시간 설정
        let intervalInSeconds = pushSettingViewModel.interval
        request.earliestBeginDate = Date(timeIntervalSinceNow: intervalInSeconds)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("백그라운드 작업 예약 실패: \(error)")
        }
    }
}
