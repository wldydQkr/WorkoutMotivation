//
//  WorkoutMotivationApp.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import SwiftUI

@main
struct WorkoutMotivationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
