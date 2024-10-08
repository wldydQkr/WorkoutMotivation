//
//  MotivationCardView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/8/24.
//

import SwiftUI

struct MotivationCardView: View {
    @State private var quotes: [String] = [
        "The best way to get started is to quit talking and begin doing.",
        "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty.",
        "Don't let yesterday take up too much of today.",
        "You learn more from failure than from success. Don’t let it stop you. Failure builds character."
    ]
    
    @State private var currentIndex: Int = 0
    @State private var isFavorited: Bool = false
    @Binding var showMotivationCardView: Bool
    
    var body: some View {
        VStack {
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

//#Preview {
//    MotivationCardView(showMotivationCardView: <#Binding<Bool>#>)
//}
