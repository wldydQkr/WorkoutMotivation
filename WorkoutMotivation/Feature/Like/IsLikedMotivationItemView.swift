//
//  IsLikedMotivationItemView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//

import SwiftUI

struct IsLikedMotivationItemView: View {
    @ObservedObject var viewModel: MotivationViewModel
    let motivation: Motivation
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text(motivation.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
                    .padding(.bottom, 5)
                
                HStack {
                    Text(motivation.name)
                        .fontWeight(.regular)
                        .foregroundColor(CustomColor.SwiftUI.customBlack2)
                    
                    Spacer()
                    Image(systemName: viewModel.isLiked(motivation) ? "heart.fill" : "heart")
                        .foregroundColor(CustomColor.SwiftUI.customBackgrond)
                        .padding(.leading)
                }
            }
            .padding()
        }
        .background(CustomColor.SwiftUI.customGreen3)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal, -8)
        .padding(.vertical, -4)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                viewModel.toggleLike(for: motivation)
            } label: {
                Label("좋아요 취소", systemImage: "heart.slash")
            }
            .tint(.red)
        }
    }
}

#Preview {
    IsLikedMotivationItemView(viewModel: MotivationViewModel(), motivation: Motivation(id: 1, title: "1", name: "1"))
}
