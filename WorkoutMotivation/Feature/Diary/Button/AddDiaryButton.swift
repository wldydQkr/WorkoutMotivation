//
//  AddDiaryButton.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/9/24.
//

import SwiftUI

struct AddDiaryButton: View {
    @StateObject var viewModel: DiaryViewModel
    
    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
                NavigationLink(destination: DiaryCreateView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(CustomColor.SwiftUI.customBlack)
//                        .padding()
//                        .background(CustomColor.SwiftUI.customGreen)
//                        .clipShape(Circle())
//                        .shadow(radius: 10)
//                        .padding()
                }
//            }
//        }
    }
}

#Preview {
    AddDiaryButton(viewModel: DiaryViewModel())
}
