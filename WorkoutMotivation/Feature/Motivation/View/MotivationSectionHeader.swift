//
//  MotivationSectionHeader.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct MotivationSectionHeader: View {
    var body: some View {
        HStack {
            Text("동기부여 명언")
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
//                .padding(.leading, 10)
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "checklist")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 25, height: 25)
                    .font(.title)
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
                    .padding(.trailing, 10)
            }
            .padding(.trailing, 10)
        }
                .background(CustomColor.SwiftUI.customBackgrond)
                .listRowInsets(EdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 0,
                    trailing: 0))
    }
}

#Preview {
    MotivationSectionHeader()
}
