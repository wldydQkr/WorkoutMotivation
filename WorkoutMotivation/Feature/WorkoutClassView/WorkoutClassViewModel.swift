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
    private var currentPage = 1
    private var isLoading = false
    var nextPageToken: String?
    
    let apiKey = "AIzaSyAyONZUg3Ibj4AiIkhE5XUY67GywvNMl88"
    
    func fetchVideos(with query: String, pageToken: String? = nil) {
        var response: YouTubeSearchResponse?
        guard !isLoading else { return }
        isLoading = true
        
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(query)&key=\(apiKey)"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: YouTubeSearchResponse.self, decoder: JSONDecoder())
            .map { response in
                response.items.map { item in
                    YoutubeVideo(id: item.id.videoId, title: item.snippet.title, thumbnail: item.snippet.thumbnails.high.url, channelTitle: item.snippet.channelTitle)
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newVideos in
                self?.videos.append(contentsOf: newVideos)
                self?.nextPageToken = response?.nextPageToken // 다음 페이지 토큰 저장
                self?.isLoading = false
            }
    }
    
    func loadMoreContentIfNeeded(currentItem: YoutubeVideo?) {
        guard let currentItem = currentItem else {
            fetchVideos(with: "헬스 루틴")
            return
        }
        
        let thresholdIndex = videos.index(videos.endIndex, offsetBy: -5)
        if videos.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            fetchVideos(with: "헬스 루틴")
        }
    }
}
