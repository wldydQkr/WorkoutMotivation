//
//  AlarmSetting.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/22/24.
//

import Foundation

struct AlarmSetting: Identifiable {
    let id: UUID
    let time: Date
    var isEnabled: Bool
    var isRepeated: Bool
}
