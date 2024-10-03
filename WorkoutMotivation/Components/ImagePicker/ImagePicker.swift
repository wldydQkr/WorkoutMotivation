//
//  ImagePicker.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 9/29/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var selectedImage: Data?
    @State private var selectedPickerItem: PhotosPickerItem? = nil
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        PhotosPicker(selection: $selectedPickerItem, matching: .images) {
            Text("이미지 선택")
        }
        .onChange(of: selectedPickerItem) { newItem in
            if let newItem = newItem {
                // 선택한 이미지를 Data로 변환
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            selectedImage = data
                        }
                    case .failure(let error):
                        print("이미지를 불러오는데 실패했습니다: \(error)")
                    }
                }
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//#Preview {
//    ImagePicker(selectedImage: <#Binding<Data?>#>)
//}
