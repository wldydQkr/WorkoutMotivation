//
//  DiaryCreateView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/15/24.
//

import SwiftUI
import PhotosUI

struct DiaryCreateView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedImage: Data? = nil
    @State private var date: Date = Date()
    
    @State private var showImagePicker: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            HStack {
                Text("새로운 다짐")
                    .foregroundStyle(CustomColor.SwiftUI.customBlack)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            .foregroundStyle(CustomColor.SwiftUI.customBlack)
            .padding()
            
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력해주세요", text: $title)
                        .padding(.vertical, 8)
                }
                Section(header: Text("내용")) {
                    TextField("내용을 입력해주세요", text: $content)
                        .padding(.vertical, 8)
//                    ResizableTextEditor(text: $content)
//                        .frame(minHeight: 100)
                }
                Section(header: Text("날짜")) {
                    Text(date.formatted())
                        .foregroundColor(.gray)
                }
                Section(header: Text("이미지")) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("이미지 선택하기")
                            .padding()
                            .background(CustomColor.SwiftUI.customBlack.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    if let imageData = selectedImage, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
            }
            .foregroundStyle(CustomColor.SwiftUI.customBlack)
            
            Button("저장") {
                viewModel.createDiary(title: title, content: content, image: selectedImage)
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundStyle(title.isEmpty || content.isEmpty ? .gray : CustomColor.SwiftUI.customBlack)
            .padding()
            .disabled(title.isEmpty || content.isEmpty)
        }
        .foregroundStyle(CustomColor.SwiftUI.customBlack)
        .background(CustomColor.SwiftUI.customBackgrond)
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images, photoLibrary: .shared())
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        selectedImage = data
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ResizableTextEditor: View {
    @Binding var text: String
    
    var body: some View {
        GeometryReader { geometry in
            TextEditor(text: $text)
                .frame(height: max(44, min(geometry.size.height, calculateHeight(for: text))))
                .background(Color.white)
                .cornerRadius(8)
        }
    }
    
    private func calculateHeight(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let textAttributes = [NSAttributedString.Key.font: font]
        let boundingRect = (text as NSString).boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 32, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: textAttributes,
            context: nil
        )
        return ceil(boundingRect.height) + 16
    }
}

//#Preview {
//    DiaryCreateView(viewModel: DiaryViewModel())
//}
