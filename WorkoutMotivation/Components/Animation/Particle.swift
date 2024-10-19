//
//  Particle.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/19/24.
//

import SwiftUI

struct Particle: Identifiable {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let opacity: Double
}
