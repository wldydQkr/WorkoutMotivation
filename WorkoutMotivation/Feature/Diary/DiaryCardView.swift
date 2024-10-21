//
//  DiaryCardView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/17/24.
//

import SwiftUI

struct DiaryCardView: View {
    var diary: Diary
    @StateObject var viewModel: DiaryViewModel
    @Binding var isEditing: Bool
    @Binding var selectedDiaries: Set<Int>
    var onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageData = diary.image, let uiImage = UIImage(data: imageData) {
                ZStack {
                    // 기본 배경
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .cornerRadius(10)
                    
                    // 다이어리 이미지
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity) // 가로를 꽉 채우고 초과분 자름
                        .cornerRadius(10)
                        .clipped()
                }
            } else { // 이미지가 없을 때 Spacer로 양 옆 간격을 유지
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 0)
                    .padding(.horizontal, 12)
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
            }
            .padding(.bottom, 8)
        }
        .background(CustomColor.SwiftUI.customBackgrond)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        
        HStack {
            VStack(alignment: .leading) {
                Text(diary.date.formatted())
                    .font(.system(size: 14))
                    .foregroundColor(CustomColor.SwiftUI.customBlack3)
                    .padding(.top, 0.5)
                    .padding(.bottom, 2)
                    .padding(.leading, 16)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            Spacer()

            Button(action: {
                showingDeleteAlert = true
                print("Ellipsis button tapped")
            }) {
                Image(systemName: "ellipsis")
                    .padding(.top, 0.5)
                    .padding(.bottom, 2)
                    .padding(.trailing, 16)
                    .foregroundColor(CustomColor.SwiftUI.customBlack3)
            }
            .alert("삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
                Button("취소", role: .cancel) {
                    // 취소 버튼 클릭 시 동작할 코드
                }
                Button("삭제", role: .destructive) {
                    viewModel.deleteDiary(id: Int64(diary.id))
                    print("삭제되었습니다.")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedDiaries: Set<Int> = []
    @Previewable @State var isEditing = false
    
    let sampleDiary = Diary(
        id: 1,
        title: "Sample Diary",
        content: "This is a sample diary content. It has some example text to show how it looks in the card view.",
        image: nil, date: Date()
    )
    
    DiaryCardView(
        diary: sampleDiary, viewModel: DiaryViewModel(),
        isEditing: $isEditing,
        selectedDiaries: $selectedDiaries,
        onDelete: {
            print("Deleted diary with ID: \(sampleDiary.id)")
        }
    )
}
