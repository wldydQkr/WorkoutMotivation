//
//  Date+.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/15/24.
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
