//
//  MotivationCotentViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import Combine
import Foundation

final class MotivationContentViewModel: ObservableObject {
    @Published var motivationVideos: [YoutubeVideo] = []
    @Published var isLoading = false // 로딩 상태를 Published로 관리
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "AIzaSyBl0WA5p710FDIgfvU5dl4P8t_io8tqYMs"
    private var nextPageToken: String?

    /// 동기부여 영상 데이터 가져오기
    func fetchMotivation(query: String, pageToken: String? = nil) {
        guard !isLoading else { return }
        isLoading = true

        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=\(query)&key=\(apiKey)"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }

        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: YouTubeSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        print("Error fetching data: \(error)")
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] response in
                    let newVideos = response.items.map {
                        YoutubeVideo(
                            id: $0.id.videoId,
                            title: $0.snippet.title,
                            thumbnail: $0.snippet.thumbnails.high.url,
                            channelTitle: $0.snippet.channelTitle
                        )
                    }
                    self?.motivationVideos.append(contentsOf: newVideos)
                    self?.nextPageToken = response.nextPageToken
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }

    /// 다음 페이지의 동기부여 영상 데이터 가져오기
    func fetchNextPage(completion: (() -> Void)? = nil) {
        guard let nextPageToken = nextPageToken, !isLoading else {
            completion?()
            return
        }

        fetchMotivation(query: "동기부여 영상", pageToken: nextPageToken)
        completion?()
    }
}
