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
                SectionHeader(title: "동기부여")
                MotivationalContentView()  // 동기부여 섹션에 해당하는 뷰
                
                // 섹션: 루틴
                SectionHeader(title: "루틴")
                RoutineContentView()  // 루틴 섹션에 해당하는 뷰
                    .environmentObject(viewModel)
                
                // 섹션: 부위별 영상
                SectionHeader(title: "부위별 운동 영상")
                TagsScrollView(selectedTag: $selectedTag, tags: tags, onTagSelected: {
                    selectedTag = $0
                    viewModel.fetchVideos(with: "\($0) 운동 루틴")
                })
                
                // 영상 리스트
                VideoListView(videos: viewModel.videos)
            }
        }
        .navigationTitle("운동 영상 추천")
        .onAppear {
            viewModel.fetchVideos(with: "\(selectedTag) 운동 루틴")
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 5)
            .padding(.horizontal)
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
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(videos) { video in
                    VideoItemView(video: video)
                }
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
            if let url = URL(string: video.url) {
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

// 루틴 섹션 뷰

struct RoutineContentView: View {
    @EnvironmentObject var viewModel: WorkoutClassViewModel
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.videos) { video in
                        VStack(alignment: .leading) { // 뷰가 나왔다 사라짐
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
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ScrollViewPreferenceKey.self, value: [geometry.frame(in: .named("scrollView")).maxY])
                })
                .onPreferenceChange(ScrollViewPreferenceKey.self) { maxY in
                    let scrollPosition = maxY.first ?? 0
                    let scrollViewHeight = UIScreen.main.bounds.height // ScrollView 높이

                    if scrollPosition > scrollViewHeight && !isLoading {
                        isLoading = true
                        viewModel.fetchVideos(with: "헬스 루틴 추천 영상", pageToken: viewModel.nextPageToken)
                    }
                }
            .coordinateSpace(name: "scrollView") // ScrollView에 이름 지정
                .padding(.horizontal)
                .onAppear {
                    viewModel.loadMoreContentIfNeeded(currentItem: viewModel.videos.last)
                }
            }
        }
        .onAppear {
            viewModel.fetchVideos(with: "헬스 루틴 추천 영상")
        }
    }
}

struct ScrollViewPreferenceKey: PreferenceKey {
    static var defaultValue: [CGFloat] = []

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    WorkoutClassView()
}
