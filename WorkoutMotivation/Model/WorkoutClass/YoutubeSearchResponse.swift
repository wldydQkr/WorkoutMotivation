//
//  YoutubeSearchResponse.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/16/24.
//

import Foundation

struct YouTubeSearchResponse: Decodable {
    let items: [YouTubeSearchItem]
    let nextPageToken: String?
}

struct YouTubeSearchItem: Decodable {
    let id: VideoID
    let snippet: Snippet
}

struct VideoID: Decodable {
    let videoId: String
}

struct Snippet: Decodable {
    let title: String
    let channelTitle: String
    let thumbnails: Thumbnail
}

struct Thumbnail: Decodable {
    let high: ThumbnailDetails
}

struct ThumbnailDetails: Decodable {
    let url: String
}
