//
//  CustomHeaderView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/6/24.
//

import SwiftUI

struct CustomHeaderView: View {
    var title: String
    var buttonTitle: String?
    var buttonImage: Image? // 이미지 추가
    var buttonAction: (() -> Void)?
    
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
                            .frame(width: 24, height: 24) // 이미지 크기 조정
                    } else if let buttonTitle = buttonTitle {
                        // 텍스트 버튼
                        Text(buttonTitle)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(CustomColor.SwiftUI.customBlack)
                    }
                }
            }
        }
        .padding()
        .background(CustomColor.SwiftUI.customBackgrond)
        .foregroundColor(CustomColor.SwiftUI.customBlack)
    }
}

#Preview {
    CustomHeaderView(title: "Title", buttonImage: Image(systemName: "person.crop.circle")) {
        print("button clicked")
    }
}
