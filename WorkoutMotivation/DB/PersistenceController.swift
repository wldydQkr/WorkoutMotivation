//
//  PersistenceController.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/17/24.
//

import CoreData

struct PersistenceController {
    static var shared = PersistenceController()

    private var containers: [String: NSPersistentContainer] = [:]

    // 지정된 모델 이름으로 Persistent Container를 가져오는 함수
    mutating func container(for modelName: String) -> NSPersistentContainer {
        if let container = containers[modelName] {
            return container
        } else {
            let newContainer = NSPersistentContainer(name: modelName)
            newContainer.loadPersistentStores { (description, error) in
                if let error = error {
                    fatalError("Unable to load persistent stores for model \(modelName): \(error)")
                }
            }
            containers[modelName] = newContainer
            return newContainer
        }
    }
    
    // 지정된 모델의 view context를 반환하는 함수
    mutating func viewContext(for modelName: String) -> NSManagedObjectContext {
        return container(for: modelName).viewContext
    }
}
