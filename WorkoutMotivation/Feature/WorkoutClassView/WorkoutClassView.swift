//
//  WorkoutClassView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/15/24.
//

import SwiftUI

// SwiftUI View
struct WorkoutClassView: View {
    @StateObject private var viewModel = WorkoutClassViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.videos) { video in
                HStack {
                    AsyncImage(url: URL(string: video.thumbnail)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 90)
                        } else if phase.error != nil {
                            Color.red
                                .frame(width: 120, height: 90)
                        } else {
                            Color.gray
                                .frame(width: 120, height: 90)
                        }
                    }
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(video.title)
                            .font(.headline)
                            .lineLimit(2)
                        Text("팔운동 관련 영상")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .onTapGesture {
                    if let url = URL(string: video.url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .navigationTitle("팔운동 영상")
            .onAppear {
                viewModel.fetchVideos()
            }
        }
    }
}

#Preview {
    WorkoutClassView()
}
