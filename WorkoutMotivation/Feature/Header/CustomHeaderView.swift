//
//  CustomHeaderView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/6/24.
//

import SwiftUI

struct CustomHeaderView<Content: View>: View {
    var title: String
    var buttonTitle: String? = nil // 텍스트 버튼 기본값 nil
    var buttonImage: Image? = nil  // 이미지 버튼 기본값 nil
    var buttonAction: (() -> Void)? = nil // 버튼 액션 기본값 nil
    @ViewBuilder var buttonContent: () -> Content // 커스텀 버튼 뷰

    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .bold()
            Spacer()
            if let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    if let buttonImage = buttonImage {
                        // 이미지 버튼
                        buttonImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    } else if let buttonTitle = buttonTitle {
                        // 텍스트 버튼
                        Text(buttonTitle)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(CustomColor.SwiftUI.customBlack)
                    }
                }
            } else {
                buttonContent() // 커스텀 버튼 뷰를 표시
            }
        }
        .padding()
        .background(CustomColor.SwiftUI.customBackgrond)
        .foregroundColor(CustomColor.SwiftUI.customBlack)
    }
}

#Preview {
    CustomHeaderView(title: "Title", buttonImage: Image(systemName: "person.crop.circle")) {
        EmptyView()
    }
}
