//
//  NetworkService.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/6/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case responseError
    case decodeError
    case serverError(statusCode: Int)
    case unknownError
}

class NetworkService {
    static let shared: NetworkService = NetworkService()
    
    func getJson(from fileName: String) -> Data? {
        let fileName: String = fileName
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    func getMotivationData() async throws -> MotivationsData {
        let jsonData = NetworkService.shared.getJson(from: "Motivation")
        
        do {
            let dictData = try JSONDecoder().decode(MotivationsData.self, from: jsonData!)
            
            return dictData
        } catch {
            throw NetworkError.decodeError
        }
    }
    
}
