//
//  EmptyView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//

import SwiftUI

struct EmptyIsLikedView: View {
    var body: some View {
        Text("좋아요 한 명언이 없습니다.")
            .foregroundColor(CustomColor.SwiftUI.customGreen)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding()
    }
}

#Preview {
    EmptyIsLikedView()
}
