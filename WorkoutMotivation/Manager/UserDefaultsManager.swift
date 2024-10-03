//
//  UserDefaultsManager.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/11/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let likedMotivationsKey = "likedMotivations"
    
    func getLikedMotivations() -> Set<UUID> {
        let savedData = defaults.array(forKey: likedMotivationsKey) as? [String] ?? []
        return Set(savedData.compactMap { UUID(uuidString: $0) })
    }
    
    func saveLikedMotivation(_ id: UUID) {
        var likedMotivations = getLikedMotivations()
        likedMotivations.insert(id)
        defaults.set(Array(likedMotivations).map { $0.uuidString }, forKey: likedMotivationsKey)
    }
    
    func removeLikedMotivation(_ id: UUID) {
        var likedMotivations = getLikedMotivations()
        likedMotivations.remove(id)
        defaults.set(Array(likedMotivations).map { $0.uuidString }, forKey: likedMotivationsKey)
    }
}
