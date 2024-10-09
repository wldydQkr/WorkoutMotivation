//
//  EditButton.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//

import SwiftUI

struct DelButton: View {
    @Environment(\.editMode) private var editMode
    @State private var isEditing = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                if let editMode = editMode?.wrappedValue {
                    isEditing.toggle()
                    self.editMode?.wrappedValue = isEditing ? .active : .inactive
                }
            }
        }) {
            Image(isEditing ? "trash" : "trash")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(CustomColor.SwiftUI.customBlack)
//                .padding(.trailing, 10)
        }
    }
}

#Preview {
    DelButton()
}
