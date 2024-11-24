//
//  MotivationCotentViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import SwiftUI
import Combine

final class MotivationCotentViewModel: ObservableObject {
    @Published var motivationVideos: [YoutubeVideo] = []
    private var cancellable: AnyCancellable?
    private var isLoading = false
    private var nextPageToken: String?
    
    private let apiKey = "AIzaSyBl0WA5p710FDIgfvU5dl4P8t_io8tqYMs"
    
    func fetchMotivation(with query: String, pageToken: String? = nil) {
        guard !isLoading else { return }
        isLoading = true
        
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=\(query)&key=\(apiKey)"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: YouTubeSearchResponse.self, decoder: JSONDecoder())
            .map { response in
                response.items.map { item in
                    YoutubeVideo(
                        id: item.id.videoId,
                        title: item.snippet.title,
                        thumbnail: item.snippet.thumbnails.high.url,
                        channelTitle: item.snippet.channelTitle
                    )
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newVideos in
                self?.motivationVideos.append(contentsOf: newVideos)
                self?.nextPageToken = pageToken // 다음 페이지 토큰 저장
                self?.isLoading = false
            }
    }
}
