//
//  WorkoutClassViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/16/24.
//

import SwiftUI
import Combine

final class WorkoutClassViewModel: ObservableObject {
    @Published var videos: [YoutubeVideo] = []
    private var cancellable: AnyCancellable?
    
    let apiKey = "AIzaSyAyONZUg3Ibj4AiIkhE5XUY67GywvNMl88"
    let searchQuery = "팔운동"
    
    func fetchVideos() {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(searchQuery)&key=\(apiKey)") else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: YouTubeSearchResponse.self, decoder: JSONDecoder())
            .map { response in
                response.items.map { item in
                    YoutubeVideo(id: item.id.videoId, title: item.snippet.title, thumbnail: item.snippet.thumbnails.high.url)
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.videos, on: self)
    }
}
