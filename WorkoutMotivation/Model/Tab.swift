//
//  Tab.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/2/24.
//

import Foundation

enum Tab: String, CaseIterable {
    case motivation = "동기부여"
    case bookmark = "좋아요"
    case diary = "다짐"
    case timer = "타이머"
    case myPage = "설정"
    
    var systemImage: String {
        switch self {
        case .motivation:
            return "flame"
        case .diary:
            return "book.closed"
        case .bookmark:
            return "heart"
        case .timer:
            return "timer"
        case .myPage:
            return "gearshape"
        }
    }
    
    var index:Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
}
