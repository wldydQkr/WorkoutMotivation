//
//  MotivationContentView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import SwiftUI
import SafariServices

struct MotivationContentView: View {
    @StateObject private var viewModel = MotivationContentViewModel()
    @State private var isLoading = false

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
                                .multilineTextAlignment(.leading)

                            Text(video.channelTitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        .frame(width: 200)
                        .onAppear {
                            if video == viewModel.motivationVideos.last {
                                isLoading = true
                                viewModel.fetchNextPage()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // 로딩 중이면 로딩 뷰 표시
            if isLoading {
                ProgressView()
                    .padding(.top, 16)
                    .onAppear {
                        isLoading = false // 로딩이 완료되면 상태 업데이트
                    }
            }
        }
        .onAppear {
            viewModel.fetchMotivation(query: "Workout Motivation Videos")
        }
    }
}

struct ScrollViewRepresentable<Content: View>: UIViewRepresentable {
    var onScrolledToBottom: (Bool) -> Void
    let content: Content
    
    init(onScrolledToBottom: @escaping (Bool) -> Void, @ViewBuilder content: () -> Content) {
        self.onScrolledToBottom = onScrolledToBottom
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onScrolledToBottom: onScrolledToBottom)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var onScrolledToBottom: (Bool) -> Void
        
        init(onScrolledToBottom: @escaping (Bool) -> Void) {
            self.onScrolledToBottom = onScrolledToBottom
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            // 감지: 스크롤이 끝에 도달하면 true
            if offsetY > contentHeight - height - 50 {
                onScrolledToBottom(true)
            } else {
                onScrolledToBottom(false)
            }
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
