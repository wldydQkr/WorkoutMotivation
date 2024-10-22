//
//  MyPageItem.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/9/24.
//

import Foundation

struct MyPageItem: Identifiable {
    var id: UUID = UUID() // 각 항목에 대한 고유 ID
    var title: String
    var action: () -> Void
}
