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
    @State private var isLoading = false // 로딩 상태 관리
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...") // 로딩 중일 때 표시
                    .padding()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.routineVideos) { video in
                        Button(action: {
                            if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                                selectedVideoURL = IdentifiableURL(url: url)
                            }
                        }) {
                            VStack(spacing: 8) { // 이미지와 텍스트 간 간격 유지
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
                                .frame(maxWidth: .infinity, alignment: .top) // 이미지가 항상 상단 고정되도록 설정
                                
                                VStack(alignment: .leading, spacing: 4) { // 텍스트 정렬
                                    Text(video.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                    Text(video.channelTitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트가 왼쪽 정렬되도록 설정
                            }
                            .frame(width: 200, alignment: .top) // 카드 크기와 정렬 고정
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            if viewModel.routineVideos.isEmpty {
                isLoading = true
                viewModel.fetchRoutine(with: "헬스 루틴 추천") {
                    isLoading = false
                }
            }
        }
        .sheet(item: $selectedVideoURL) { identifiableURL in
            SafariView(url: identifiableURL.url)
        }
    }
}
