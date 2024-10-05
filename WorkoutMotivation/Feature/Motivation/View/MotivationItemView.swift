//
//  MotivationItemView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct MotivationItemView: View {
    let motivation: Motivation
    @ObservedObject var viewModel: MotivationViewModel
    @Binding var isShareSheetPresented: Bool
    @Binding var shareContent: String

    var body: some View {
        NavigationLink(destination: MotivationDetailView(title: motivation.title, name: motivation.name, motivation: motivation, viewModel: MotivationViewModel())) {
            VStack {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(CustomColor.SwiftUI.customGreen3)
                        .frame(height: 170)
                    Text(motivation.title)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(CustomColor.SwiftUI.customBlack)
                        .padding()
                }
                HStack {
                    Button(action: {
                        viewModel.toggleLike(for: motivation)
                    }) {
                        Image(systemName: viewModel.isLiked(motivation) ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(viewModel.isLiked(motivation) ? CustomColor.SwiftUI.customGreen : CustomColor.SwiftUI.customBlack)
                            .padding(.leading)
                    }
                    Spacer()
                    Text(motivation.name)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .foregroundStyle(CustomColor.SwiftUI.customBlack)
                        .padding(.trailing)
                }
                Spacer()
            }
            .background(CustomColor.SwiftUI.customGreen3)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .contextMenu {
                Button(action: {
                    // 먼저 shareContent를 설정한 후, 비동기로 시트를 열기
                    shareContent = viewModel.getMotivationDetails(motivation)
                    
                    // 상태가 업데이트된 후 시트를 띄우기 위해 비동기로 처리
                    DispatchQueue.main.async {
                        isShareSheetPresented = true
                    }
                }) {
                    Label("공유", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
//#Preview {
//    MotivationItemView()
//}
