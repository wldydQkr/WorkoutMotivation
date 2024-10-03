//
//  Motivation.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/2/24.
//

import Foundation

struct Motivation: Codable, Identifiable {
    let id: Int
    let title: String
    let name: String
}

struct MotivationsData: Codable {
    let motivations: [Motivation]
}
