//
//  NotificationItem.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/8/24.
//

import Foundation

struct NotificationItem: Codable {
    var id = UUID()
    var date: Date
    var motivation: Motivation?
    var repeats: Bool = false
}
