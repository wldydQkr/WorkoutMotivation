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
    @Published var isLoading = false
    private var cancellable: AnyCancellable?
    var nextPageToken: String?

    private let apiKey = "AIzaSyBl0WA5p710FDIgfvU5dl4P8t_io8tqYMs"
    
    private var selectedTag: String = "팔" // 기본 태그 설정

    func updateSelectedTag(_ tag: String) {
        selectedTag = tag
        videos.removeAll()
        nextPageToken = nil
        fetchVideos(with: selectedTag)
    }

    func fetchVideos(with query: String, pageToken: String? = nil) {
        guard !isLoading else { return } // 중복 요청 방지
        isLoading = true

        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(query)&key=\(apiKey)"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }

        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("잘못된 URL: \(urlString)")
            isLoading = false
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: YouTubeSearchResponse.self, decoder: JSONDecoder())
            .map { response in
//                self.nextPageToken = response.nextPageToken // 페이지 토큰 업데이트
                return response.items.map { item in
                    YoutubeVideo(
                        id: item.id.videoId,
                        title: item.snippet.title,
                        thumbnail: item.snippet.thumbnails.high.url,
                        channelTitle: item.snippet.channelTitle
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("에러 발생: \(error.localizedDescription)")
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] newVideos in
                self?.videos.append(contentsOf: newVideos)
                self?.isLoading = false
            })
    }

    func loadMoreContentIfNeeded(tag: String, currentItem: YoutubeVideo?) {
        guard let currentItem = currentItem, !isLoading else { return }

        let thresholdIndex = videos.index(videos.endIndex, offsetBy: -5)
        if videos.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            fetchVideos(with: tag, pageToken: nextPageToken)
        }
    }
}
