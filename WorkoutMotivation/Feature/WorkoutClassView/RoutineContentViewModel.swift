//
//  RoutineContentViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/21/24.
//

import SwiftUI
import Combine

final class RoutineContentViewModel: ObservableObject {
    @Published var routineVideos: [YoutubeVideo] = []
    private var cancellable: AnyCancellable?
    private var isLoading = false
    private let apiKey = "AIzaSyBl0WA5p710FDIgfvU5dl4P8t_io8tqYMs"
    
    func fetchRoutine(with query: String, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(query)&key=\(apiKey)"
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
                guard let self = self else { return }
                // 중복 제거
                let uniqueVideos = newVideos.filter { newVideo in
                    !self.routineVideos.contains(where: { $0.id == newVideo.id })
                }
                self.routineVideos.append(contentsOf: uniqueVideos)
                self.isLoading = false
                completion()
            }
    }
}
