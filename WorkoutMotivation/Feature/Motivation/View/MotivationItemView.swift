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
                        .fill(CustomColor.SwiftUI.customBackgrond)
                        .frame(height: calculateHeightForText(motivation.title))
                    
                    Text(motivation.title)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(CustomColor.SwiftUI.customBlack)
                        .padding(.top, 20)
                        .padding([.leading, .trailing], 16)
                }
                HStack {
                    Button(action: {
                        viewModel.toggleLike(for: motivation)
                    }) {
                        Image(systemName: viewModel.isLiked(motivation) ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(viewModel.isLiked(motivation) ? .pink : CustomColor.SwiftUI.customGreen3)
                            .padding(.leading)
                    }
                    Spacer()
                    Text(motivation.name)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .foregroundStyle(CustomColor.SwiftUI.customBlack2)
                        .padding(.trailing)
                }
                Spacer()
            }
            .background(CustomColor.SwiftUI.customBackgrond)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .contextMenu {
                Button(action: {
                    shareContent = viewModel.getMotivationDetails(motivation)
                    print(shareContent)
                    DispatchQueue.main.async {
                        isShareSheetPresented = true
                    }
                }) {
                    Label("공유", systemImage: "square.and.arrow.up")
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func calculateHeightForText(_ text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let textSize = text.boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.infinity),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return max(100, textSize.height + 60) // 상단 패딩을 포함한 높이
    }
}

#Preview {
    @Previewable @State var shareContent = ""
    @Previewable @State var isShareSheetPresented = false
    let sampleMotivation = Motivation(id: 1, title: "Stay Focused", name: "John Doe")
    
    MotivationItemView(
        motivation: sampleMotivation,
        viewModel: MotivationViewModel(),
        isShareSheetPresented: $isShareSheetPresented,
        shareContent: $shareContent
    )
    .previewLayout(.sizeThatFits) // 프리뷰 레이아웃 설정
}
