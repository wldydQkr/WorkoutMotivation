//
//  DiaryCardView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/17/24.
//

import SwiftUI

struct DiaryCardView: View {
    var diary: Diary
    @Binding var isEditing: Bool
    @Binding var selectedDiaries: Set<Int>
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageData = diary.image, let uiImage = UIImage(data: imageData) {
                ZStack {
                    // 기본 배경이 될 Rectangle
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                    
                    // 다이어리 이미지
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()   // 이미지 비율 유지
                        .frame(height: 200)
                        .cornerRadius(10)
                        .clipped()       // 이미지가 frame을 넘으면 잘라냄
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                }
            } else { // 이미지가 없을 때 Spacer로 양 옆 간격을 유지
                Rectangle()
                    .fill(Color.clear)   // 보이지 않게 설정
                    .frame(height: 0)    // 높이 0으로 설정
                    .padding(.horizontal, 12)  // 가로 간격 유지
            }
            
            // 다이어리 제목 및 내용
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(diary.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(CustomColor.SwiftUI.customBlack)
                        .padding(.horizontal, 8)
                    
                    Text(diary.content)
                        .lineLimit(3)
                        .font(.system(size: 14))
                        .foregroundColor(CustomColor.SwiftUI.customBlack2)
                        .padding(.horizontal, 8)
                }
                
                Spacer() // 오른쪽 정렬을 위해 Spacer 사용
                
                Text(diary.date.formatted())
                    .font(.system(size: 14))
                    .foregroundColor(CustomColor.SwiftUI.customBlack3)
                    .padding(.trailing, 8)
                    .frame(maxHeight: .infinity, alignment: .bottom) // 높이 맞춤
            }
            .padding(.bottom, 8)
            
        }
        .background(CustomColor.SwiftUI.customGreen3)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal, 12)  // 양옆 간격 8 적용
        .padding(.vertical, 4)
    }
}

//import SwiftUI
//
//struct DiaryCardView: View {
//    var diary: Diary
//    @Binding var isEditing: Bool
//    @Binding var selectedDiaries: Set<Int>
//    var onDelete: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading, spacing: 10) {
//                // Title
//                Text(diary.title)
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(CustomColor.SwiftUI.customGreen)
//                    .padding(.bottom, 5)
//                
//                // Author and Date
//                HStack {
//                    Text(diary.content)
//                        .fontWeight(.regular)
//                        .lineLimit(5)
//                        .foregroundColor(.secondary)
//                    
//                    Spacer()
//                    
//                    Text(diary.date.formatted())
//                        .fontWeight(.regular)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//        }
//        .background(CustomColor.SwiftUI.customGreen3)
//        .cornerRadius(10)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
//        .padding(.horizontal, -8) // Adjust padding to match style
//        .listRowBackground(Color.clear) // Transparent background for list rows
//        .listRowSeparator(.hidden) // Remove the list separator line
//        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//            Button {
//                onDelete() // Delete action
//            } label: {
//                Label("삭제", systemImage: "trash")
//            }
//            .tint(.red)
//        }
//    }
//}


//#Preview {
//    DiaryCardView()
//}
