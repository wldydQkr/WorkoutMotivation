//
//  MotivationContentView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 11/22/24.
//

import SwiftUI
import SafariServices
import Combine

struct MotivationContentView: View {
    @StateObject private var viewModel = MotivationContentViewModel()

    var body: some View {
        VStack {
            if viewModel.motivationVideos.isEmpty && viewModel.isLoading {
                ProgressView("Loading videos...")
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.motivationVideos) { video in
                            VStack(alignment: .leading) {
                                AsyncImage(url: URL(string: video.thumbnail)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 200, height: 120)
                                            .clipped()
                                    case .failure:
                                        Color.red.frame(width: 200, height: 120)
                                    default:
                                        Color.gray.frame(width: 200, height: 120)
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
                            // .onAppear {
                            //     if video == viewModel.motivationVideos.last {
                            //         viewModel.fetchNextPage()
                            //     }
                            // }
                        }

                        // if viewModel.isLoading {
                        //     ProgressView()
                        //         .frame(width: 200, height: 120)
                        // }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchMotivation(query: "동기부여 영상")
        }
        // .onChange(of: viewModel.isLoading) { _ in
        //     // Handle loading state changes
        // }
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
