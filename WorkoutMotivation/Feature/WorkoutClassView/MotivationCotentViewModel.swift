//
//  MotivationCotentViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import Foundation
import Combine

final class MotivationContentViewModel: ObservableObject {
    @Published var motivationVideos: [YoutubeVideo] = []
    private var cancellables = Set<AnyCancellable>()
    var nextPageToken: String? // 다음 페이지 토큰
    private let apiKey = "AIzaSyBl0WA5p710FDIgfvU5dl4P8t_io8tqYMs"
    var isLoading = false

    func fetchMotivation(query: String, pageToken: String? = nil) {
        guard !isLoading else { return }
        isLoading = true

        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=\(query)&key=\(apiKey)"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
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
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        print("Error fetching data: \(error)")
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] newVideos in
                    guard let self = self else { return }
                    // 중복 제거: 기존 목록에 없는 새로운 동영상만 추가
                    let uniqueVideos = newVideos.filter { newVideo in
                        !self.motivationVideos.contains(where: { $0.id == newVideo.id })
                    }
                    self.motivationVideos.append(contentsOf: uniqueVideos)
                    self.nextPageToken = nil // 다음 페이지 토큰 초기화
                    self.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}
