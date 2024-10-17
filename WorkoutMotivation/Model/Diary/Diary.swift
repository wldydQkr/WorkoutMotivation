//
//  Diary.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/15/24.
//

import Foundation

struct Diary: Identifiable, Equatable {
    let id: Int
    var title: String
    var content: String
    var image: Data?
    var date: Date
}
