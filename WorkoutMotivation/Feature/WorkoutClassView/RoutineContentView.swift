//
//  Untitled.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/21/24.
//

import SwiftUI
import SafariServices

struct RoutineContentView: View {
    @StateObject private var viewModel = RoutineContentViewModel()
    @State private var selectedVideoURL: IdentifiableURL?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.routineVideos) { video in
                        VStack(alignment: .leading) {
                            Button(action: {
                                if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                                    selectedVideoURL = IdentifiableURL(url: url)
                                }
                            }) {
                                VStack {
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
                                        .multilineTextAlignment(.leading)
                                    Text(video.channelTitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(width: 200)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchRoutine(with: "헬스 루틴 추천")
            }
        }
        .sheet(item: $selectedVideoURL) { identifiableURL in
            SafariView(url: identifiableURL.url)
        }
    }
}
