//
//  YoutubeVideo.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/16/24.
//

import Foundation

struct YoutubeVideo: Identifiable {
    let id: String
    let title: String
    let thumbnail: String
    let channelTitle: String
    var url: String { "https://www.youtube.com/watch?v=\(id)" }
}
