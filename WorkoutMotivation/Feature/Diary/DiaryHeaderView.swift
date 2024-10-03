//
//  DiaryHeaderView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/15/24.
//

import SwiftUI

struct DiaryHeaderView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Binding var isEditing: Bool
    @Binding var selectedDiaries: Set<Int>
    
    var body: some View {
        HStack {
            Text("나의 다짐")
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
//            DelButton()
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
    
    private func deleteSelectedDiaries() {
        selectedDiaries.forEach { id in
            viewModel.deleteDiary(id: Int64(id))
        }
        selectedDiaries.removeAll()
    }
}


//#Preview {
//    DiaryHeaderView(viewModel: DiaryViewModel())
//}
