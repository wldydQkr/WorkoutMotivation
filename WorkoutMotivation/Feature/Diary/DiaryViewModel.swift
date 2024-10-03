//
//  DiaryViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//

import SwiftUI
import Combine
import CoreData

class DiaryViewModel: ObservableObject {
    @Published var diaries: [Diary] = []
    private var cancellables: Set<AnyCancellable> = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        fetchDiaries()
    }
    
    func createDiary(title: String, content: String, image: Data?) {
        let newDiary = DiaryEntity(context: context) // CoreData Entity 생성
        newDiary.id = Int64(Date().timeIntervalSince1970) // 고유 ID 생성
        newDiary.title = title
        newDiary.content = content
        newDiary.date = Date()
        
        // 단일 이미지를 BinaryData로 저장
        newDiary.image = image

        saveContext() // CoreData 저장
        fetchDiaries()
    }
    
    func readDiary(id: Int64) -> DiaryEntity? {
        let fetchRequest: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch diary: \(error)")
            return nil
        }
    }
    
    func updateDiary(id: Int64, title: String, content: String, image: Data?) {
        if let diary = readDiary(id: id) {
            diary.title = title
            diary.content = content
            diary.image = image // 이미지가 선택되지 않으면 nil이 전달될 수 있음
//            diary.date = Date()
            
            saveContext()
            fetchDiaries() // 데이터 업데이트 후 fetch
        }
    }
    
    func deleteDiary(id: Int64) {
        if let diary = readDiary(id: id) {
            context.delete(diary)
            saveContext()
            fetchDiaries() // 삭제 후 fetch
        }
    }
    
    private func fetchDiaries() {
        let fetchRequest: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        
        do {
            let fetchedDiaries = try context.fetch(fetchRequest)
            // Diary 객체 생성 시 이미지 포함
            self.diaries = fetchedDiaries.map { Diary(id: Int($0.id), title: $0.title ?? "", content: $0.content ?? "", image: $0.image ?? Data(), date: $0.date ?? Date()) }
        } catch {
            print("Failed to fetch diaries: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func reload() async {
        fetchDiaries() // 데이터를 새로 고침
        objectWillChange.send() // 데이터 변경 알림
    }
}
