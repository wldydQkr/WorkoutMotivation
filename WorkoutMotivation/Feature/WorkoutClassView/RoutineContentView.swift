//
//  Untitled.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/21/24.
//

import SwiftUI

struct RoutineContentView: View {
    @StateObject private var viewModel = RoutineContentViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.routineVideos) { video in
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
                viewModel.fetchRoutine(with: "헬스 루틴 추천")
            }
        }
    }
}
