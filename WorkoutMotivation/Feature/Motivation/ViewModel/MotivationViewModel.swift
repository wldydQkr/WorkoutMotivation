//
//  MotivationViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import Foundation

final class MotivationViewModel: ObservableObject {
    @Published var motivations: [Motivation] = []
    @Published var errorMessage: String?
    @Published var likedStatus: [Int: Bool] = [:]
    @Published var likedMotivations: [Int] = [] {
        didSet {
            saveLikedMotivations()
        }
    }
    @Published var isLoading: Bool = false // 로딩 상태 변수 추가
    
    private let userDefaultsKey = "likedMotivations"
    
    init() {
        loadMotivations()
        loadLikedMotivations()
    }
    
    private var itemHeights: [Int: CGFloat] = [:]  // 각 Motivation의 id(Int)로 높이를 관리

    func updateItemHeight(motivation: Motivation, height: CGFloat) {
        itemHeights[motivation.id] = height  // Motivation의 id(Int)로 높이 저장
    }
    
    func loadMotivations() {
        guard let url = Bundle.main.url(forResource: "Motivation", withExtension: "json") else {
            errorMessage = "JSON 파일을 찾을 수 없습니다."
            return
        }
        
        isLoading = true // 로딩 상태 시작
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(MotivationsData.self, from: data)
                DispatchQueue.main.async {
                    self.motivations = decodedData.motivations
                    self.likedStatus = self.motivations.reduce(into: [:]) { $0[$1.id] = false } // 초기 좋아요 상태 설정
                    self.isLoading = false // 로딩 상태 종료
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "데이터를 로드하는 중 오류가 발생했습니다: \(error.localizedDescription)"
                    self.isLoading = false // 로딩 상태 종료
                }
            }
        }
    }
    
    func toggleLike(for motivation: Motivation) {
        if let index = likedMotivations.firstIndex(of: motivation.id) {
            likedMotivations.remove(at: index)
        } else {
            likedMotivations.append(motivation.id)
        }
        objectWillChange.send() // 변경 사항을 즉시 알림
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

    func loadLikedMotivations() {
        if let savedLikes = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            likedMotivations = savedLikes
        }
    }
    
    func getMotivationDetails(_ motivation: Motivation) -> String {
        return "\(motivation.title)\n-\(motivation.name)"
    }
    
    func reload() async {
        loadMotivations()
        objectWillChange.send() // 데이터 변경 알림
    }
    
}
