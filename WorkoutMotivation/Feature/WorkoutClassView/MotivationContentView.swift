//
//  MotivationContentView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import SwiftUI
import SafariServices

struct MotivationContentView: View {
    @StateObject private var viewModel = MotivationCotentViewModel()
    @State private var selectedVideoURL: IdentifiableURL? // Identifiable URL로 변경
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.motivationVideos) { video in
                        VStack(alignment: .leading) {
                            // 카드 클릭 시 selectedVideoURL에 URL 설정
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
                viewModel.fetchMotivation(with: "동기부여 영상")
            }
        }
        // 선택된 URL이 있을 때 SafariView를 Sheet로 표시
        .sheet(item: $selectedVideoURL) { identifiableURL in
            SafariView(url: identifiableURL.url)
        }
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID() // 고유 식별자
    let url: URL
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 업데이트 로직이 필요하지 않음
    }
}

#Preview {
    MotivationContentView()
}
