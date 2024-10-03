//
//  MotivationDetailViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/11/24.
//

import Foundation

final class MotivationDetailViewModel: ObservableObject {
    @Published var motivations: [Motivation] = []
    @Published var errorMessage: String?
    @Published var likedStatus: [Int: Bool] = [:]
    @Published var likedMotivations: [Int] = [] {
        didSet {
            saveLikedMotivations()
        }
    }
    private let userDefaultsKey = "likedMotivations"
    
    init() {
        loadLikedMotivations()
    }
    
    func toggleLike(for motivation: Motivation) {
        if let index = likedMotivations.firstIndex(of: motivation.id) {
            likedMotivations.remove(at: index)
        } else {
            likedMotivations.append(motivation.id)
        }
    }

    func isLiked(_ motivation: Motivation) -> Bool {
        likedMotivations.contains(motivation.id)
    }

    private func saveLikedMotivations() {
        UserDefaults.standard.set(likedMotivations, forKey: userDefaultsKey)
    }
    
    func removeLikedMotivation(at offsets: IndexSet) {
        likedMotivations.remove(atOffsets: offsets)
    }

    private func loadLikedMotivations() {
        if let savedLikes = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            likedMotivations = savedLikes
        }
    }
    
    func getMotivationDetails(_ motivation: Motivation) -> String {
        return "\(motivation.title)\n-\(motivation.name)"
    }
}
