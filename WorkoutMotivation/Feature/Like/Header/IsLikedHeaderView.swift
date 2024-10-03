//
//  IsLikedHeaderView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//

import SwiftUI

struct IsLikedHeaderView: View {
    var body: some View {
        HStack {
            Text("좋아하는 명언")
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
//                .padding(.leading, 10)
            Spacer()
            DelButton()
//                .padding(.trailing, 10)
        }
        .background(CustomColor.SwiftUI.customBackgrond)
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0))
    }
}

#Preview {
    IsLikedHeaderView()
}
