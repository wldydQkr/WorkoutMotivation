//
//  WorkoutMotivationApp.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import SwiftUI
import TipKit

@main
struct WorkoutMotivationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
    
    init() {
        /// Load and configure the state of all the tips of the app
        try? Tips.configure()
    }
}
