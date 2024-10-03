//
//  MyPageItem.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/9/24.
//

import Foundation

struct MyPageItem: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}
