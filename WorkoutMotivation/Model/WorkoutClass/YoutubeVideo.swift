//
//  YoutubeVideo.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/16/24.
//

import Foundation

// YouTube API 응답 모델
struct YoutubeVideo: Identifiable, Decodable {
    var id: String
    var title: String
    var thumbnail: String
    var url: String { "https://www.youtube.com/watch?v=\(id)" }
    
    enum CodingKeys: String, CodingKey {
        case title = "snippet.title"
        case thumbnail = "snippet.thumbnails.high.url"
        case id = "id.videoId"
    }
}
