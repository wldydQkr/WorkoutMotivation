//
//  MotivationViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import Foundation
import FirebaseDatabaseInternal
import Combine

final class MotivationViewModel: ObservableObject {
    static let shared = MotivationViewModel() // 싱글톤 인스턴스
    
    @Published var motivations: [Motivation] = []
    @Published var errorMessage: String?
    @Published var likedStatus: [Int: Bool] = [:]
    @Published var likedMotivations: [Int] = [] {
        didSet {
            saveLikedMotivations()
        }
    }
    @Published var isLoading: Bool = false // 로딩 상태 변수 추가

    private var databaseRef: DatabaseReference!
    private let userDefaultsKey = "likedMotivations"

    init() {
        self.databaseRef = Database.database().reference()
        loadMotivations()
        loadLikedMotivations()
    }

    private var itemHeights: [Int: CGFloat] = [:]  // 각 Motivation의 id(Int)로 높이를 관리

    func updateItemHeight(motivation: Motivation, height: CGFloat) {
        itemHeights[motivation.id] = height  // Motivation의 id(Int)로 높이 저장
    }

    // Firebase에서 Motivation 데이터를 로드
    func loadMotivations() {
        isLoading = true // 로딩 상태 시작
        databaseRef.child("motivations").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                DispatchQueue.main.async {
                    self.errorMessage = "Firebase에서 데이터를 가져올 수 없습니다."
                    self.isLoading = false // 로딩 상태 종료
                }
                return
            }

            DispatchQueue.global(qos: .background).async {
                do {
                    // 데이터를 JSON 형식으로 변환하고 디코딩
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let decodedData = try JSONDecoder().decode([Motivation].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.motivations = decodedData.shuffled() // 데이터를 랜덤으로 섞어서 저장
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
    }

    // 랜덤으로 Motivation을 반환하는 함수
    func getRandomMotivation() -> Motivation? {
        return motivations.randomElement()
    }

    // 좋아요 상태 토글
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

    // UserDefaults에 좋아요 저장
    private func saveLikedMotivations() {
        UserDefaults.standard.set(likedMotivations, forKey: userDefaultsKey)
    }

    // 좋아요 삭제
    func removeLikedMotivation(at offsets: IndexSet) {
        likedMotivations.remove(atOffsets: offsets)
    }

    // UserDefaults에서 좋아요 로드
    func loadLikedMotivations() {
        if let savedLikes = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            likedMotivations = savedLikes
        }
    }

    // Motivation 상세 정보 반환
    func getMotivationDetails(_ motivation: Motivation) -> String {
        return "\(motivation.title)\n-\(motivation.name)"
    }

    // 데이터를 리로드하는 함수
    func reload() async {
        loadMotivations()
        objectWillChange.send() // 데이터 변경 알림
    }
}

//func loadMotivationsForJSON() {
//    guard let url = Bundle.main.url(forResource: "Motivation", withExtension: "json") else {
//        errorMessage = "JSON 파일을 찾을 수 없습니다."
//        return
//    }
//
//    isLoading = true // 로딩 상태 시작
//    DispatchQueue.global(qos: .background).async {
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            let decodedData = try decoder.decode(MotivationsData.self, from: data)
//            DispatchQueue.main.async {
//                // 데이터 로드 후 섞기
//                self.motivations = decodedData.motivations.shuffled() // 랜덤으로 섞어서 저장
//                self.likedStatus = self.motivations.reduce(into: [:]) { $0[$1.id] = false } // 초기 좋아요 상태 설정
//                self.isLoading = false // 로딩 상태 종료
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "데이터를 로드하는 중 오류가 발생했습니다: \(error.localizedDescription)"
//                self.isLoading = false // 로딩 상태 종료
//            }
//        }
//    }
//}
