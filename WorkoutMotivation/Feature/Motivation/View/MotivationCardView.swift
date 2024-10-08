//
//  MotivationCardView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/8/24.
//

import SwiftUI
import TipKit

//MARK: TIPView
struct MotivationCardView: View {
    @State private var quotes: [String] = [
        "The best way to get started is to quit talking and begin doing.",
        "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty.",
        "Don't let yesterday take up too much of today.",
        "You learn more from failure than from success. Don’t let it stop you. Failure builds character."
    ]
    
    @State private var currentIndex: Int = 0
    @State private var isFavorited: Bool = false
    @State private var showTip: Bool = true // 팁 뷰의 표시 상태
    @Binding var showMotivationCardView: Bool
    let inlineFavoriteTip = AddToFavoriteTip()
    
    var body: some View {
        VStack {
            // TipKit 팁 뷰
            if showTip {
                if #available(iOS 18.0, *) {
                    TipView(inlineFavoriteTip)
                        .foregroundStyle(.customBlack)
                        .padding()
//                        .transition(.slide)
                        .onAppear {
                            // 3초 후에 팁 뷰 사라짐
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                withAnimation {
//                                    showTip = false
//                                }
//                            }
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            Text(quotes[currentIndex])
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: {
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .gray)
                        .font(.title)
                }
                
                Spacer()
                
                Button(action: {
                    shareQuote(quote: quotes[currentIndex])
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.height < 0 {
                        // 아래서 위로 Swipe 했을 때 다음 명언으로 넘어감
                        withAnimation {
                            currentIndex = (currentIndex + 1) % quotes.count
                        }
                    } else if value.translation.height > 0 {
                        // 위에서 아래로 Swipe 했을 때 이전 명언으로 돌아감
                        withAnimation {
                            currentIndex = (currentIndex - 1 + quotes.count) % quotes.count
                        }
                    }
                }
        )
    }
    
    func shareQuote(quote: String) {
        let activityController = UIActivityViewController(activityItems: [quote], applicationActivities: nil)
        
        // UIKit과 연동
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
        }
    }
}

struct AddToFavoriteTip: Tip {
    var title: Text {
        Text("아래에서 위로 쓸어 넘기세요!")
    }
    var message: Text? {
        Text("이전 글귀를 볼려면 위에서 아래로 쓸어 넘기세요!")
    }
    var image: Image? {
        Image(systemName: "arrow.up.arrow.down")
    }
}

//struct MotivationCardView: View {
//    @State private var quotes: [String] = [
//        "The best way to get started is to quit talking and begin doing.",
//        "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty.",
//        "Don't let yesterday take up too much of today.",
//        "You learn more from failure than from success. Don’t let it stop you. Failure builds character."
//    ]
//    
//    @State private var currentIndex: Int = 0
//    @State private var isFavorited: Bool = false
//    @State private var showTipView: Bool = true // 팁 뷰의 표시 상태
//    @Binding var showMotivationCardView: Bool
//    
//    var body: some View {
//        VStack {
//            // 팁 뷰
//            if showTipView {
//                Text("아래에서 위로 쓸어 올리세요")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//                    .padding()
//                    .transition(.opacity) // 부드러운 전환 효과
//                    .onAppear {
//                        // 3초 후에 팁 뷰 사라짐
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            withAnimation {
//                                showTipView = false
//                            }
//                        }
//                    }
//            }
//            
//            Text(quotes[currentIndex])
//                .font(.title)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)
//                .padding()
//            
//            Spacer()
//            
//            HStack {
//                Button(action: {
//                    isFavorited.toggle()
//                }) {
//                    Image(systemName: isFavorited ? "heart.fill" : "heart")
//                        .foregroundColor(isFavorited ? .red : .gray)
//                        .font(.title)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    shareQuote(quote: quotes[currentIndex])
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.title)
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 50)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.white)
//        .cornerRadius(20)
//        .shadow(radius: 10)
//        .padding()
//        .gesture(
//            DragGesture(minimumDistance: 50)
//                .onEnded { value in
//                    if value.translation.height < 0 {
//                        // 아래서 위로 Swipe 했을 때 다음 명언으로 넘어감
//                        withAnimation {
//                            currentIndex = (currentIndex + 1) % quotes.count
//                        }
//                    } else if value.translation.height > 0 {
//                        // 위에서 아래로 Swipe 했을 때 이전 명언으로 돌아감
//                        withAnimation {
//                            currentIndex = (currentIndex - 1 + quotes.count) % quotes.count
//                        }
//                    }
//                }
//        )
//    }
//    
//    func shareQuote(quote: String) {
//        let activityController = UIActivityViewController(activityItems: [quote], applicationActivities: nil)
//        
//        // UIKit과 연동
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            windowScene.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
//        }
//    }
//}

//#Preview {
//    MotivationCardView(showMotivationCardView: <#Binding<Bool>#>)
//}
