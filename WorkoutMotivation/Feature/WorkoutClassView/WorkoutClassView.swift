//
//  WorkoutClassView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/15/24.
//

import SwiftUI
import Combine

struct WorkoutClassView: View {
    @StateObject private var viewModel = WorkoutClassViewModel()
    @State private var selectedTag: String = "팔"

    let tags = ["팔", "상체", "하체", "등", "가슴", "복근", "어깨"]

    var body: some View {
        ScrollView {
            VStack {
                // 섹션: 동기부여
                CustomHeaderView(title: "동기부여") {
                    EmptyView()
                }
                MotivationalContentView()
                
                // 섹션: 루틴
                CustomHeaderView(title: "루틴") {
                    EmptyView()
                }
                RoutineContentView()

                // 섹션: 부위별 영상
                CustomHeaderView(title: "부위별 운동 영상") {
                    EmptyView()
                }
                TagsScrollView(selectedTag: $selectedTag, tags: tags, onTagSelected: { tag in
                    selectedTag = tag
                    viewModel.updateSelectedTag("\(tag) 운동 루틴")
                })

                // 비디오 리스트
                VideoListView(
                    videos: viewModel.videos,
                    onScrolledToEnd: {
                        viewModel.loadMoreContentIfNeeded(tag: selectedTag, currentItem: viewModel.videos.last)
                    },
                    isLoading: viewModel.isLoading
                )
            }
        }
        .background(CustomColor.SwiftUI.customBackgrond)
        .navigationTitle("운동 영상 추천")
        .onAppear {
            viewModel.updateSelectedTag("\(selectedTag) 운동 추천")
        }
    }
}

struct TagsScrollView: View {
    @Binding var selectedTag: String
    let tags: [String]
    let onTagSelected: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Button(action: {
                        selectedTag = tag
                        onTagSelected(tag)
                    }) {
                        Text(tag)
                            .padding(8)
                            .background(selectedTag == tag ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct VideoListView: View {
    let videos: [YoutubeVideo]
    let onScrolledToEnd: () -> Void
    let isLoading: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(videos) { video in
                    VideoItemView(video: video)
                }

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
            }
            .onAppear {
                print("VideoListView appeared with \(videos.count) videos")
                onScrolledToEnd()
            }
        }
    }
}

struct VideoItemView: View {
    let video: YoutubeVideo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: video.thumbnail)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 90)
                            .clipped()
                    } else if phase.error != nil {
                        Color.red
                            .frame(width: 120, height: 90)
                    } else {
                        Color.gray
                            .frame(width: 120, height: 90)
                    }
                }
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.headline)
                        .lineLimit(2)
                    Text(video.channelTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 4)
            Divider()
        }
        .padding(.horizontal)
        .onTapGesture {
            if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                UIApplication.shared.open(url)
            }
        }
    }
}

// 동기부여 섹션 뷰
struct MotivationalContentView: View {
    var body: some View {
        VStack {
            Text("오늘도 최선을 다하자!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("운동은 자기 자신을 위한 투자입니다. 꾸준한 노력은 분명히 좋은 결과를 가져옵니다.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding([.leading, .trailing])
        }
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}

#Preview {
    WorkoutClassView()
}
