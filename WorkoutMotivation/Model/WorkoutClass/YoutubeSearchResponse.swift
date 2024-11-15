//
//  YoutubeSearchResponse.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/16/24.
//

import Foundation

struct YouTubeSearchResponse: Decodable {
    var items: [YouTubeSearchItem]
}

struct YouTubeSearchItem: Decodable {
    var id: VideoID
    var snippet: Snippet
}

struct VideoID: Decodable {
    var videoId: String
}

struct Snippet: Decodable {
    var title: String
    var thumbnails: Thumbnails
}

struct Thumbnails: Decodable {
    var high: Thumbnail
}

struct Thumbnail: Decodable {
    var url: String
}
