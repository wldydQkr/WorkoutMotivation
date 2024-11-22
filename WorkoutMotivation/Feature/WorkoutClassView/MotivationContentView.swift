//
//  MotivationContentView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import SwiftUI

struct MotivationContentView: View {
    @StateObject private var viewModel = MotivationCotentViewModel()
    let video: YoutubeVideo
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.motivationVideos) { video in
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: video.thumbnail)) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 120)
                                        .clipped()
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 200, height: 120)
                                } else {
                                    Color.gray
                                        .frame(width: 200, height: 120)
                                }
                            }
                            .cornerRadius(8)
                            
                            Text(video.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(video.channelTitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        .frame(width: 200)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchMotivation(with: "헬스 동기부여 영상")
            }
        }
        .onTapGesture {
            if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    MotivationContentView(video: YoutubeVideo(id: "1", title: "", thumbnail: "", channelTitle: ""))
}
