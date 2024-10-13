//
//  Array+.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/13/24.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
