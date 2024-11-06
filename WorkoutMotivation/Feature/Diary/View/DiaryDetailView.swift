//
//  DiaryDetailView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/15/24.
//

import SwiftUI
import PhotosUI

struct DiaryDetailView: View {
    @ObservedObject var viewModel: DiaryViewModel
    var diary: Diary
    
    @State private var title: String
    @State private var content: String
    @State private var image: Data
    @State private var date: Date
    
    @State private var showImagePicker: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showDeleteAlert: Bool = false // 삭제 확인 알럿 표시 여부

    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: DiaryViewModel, diary: Diary) {
        self.viewModel = viewModel
        self.diary = diary
        _title = State(initialValue: diary.title)
        _content = State(initialValue: diary.content)
        _image = State(initialValue: diary.image ?? Data())
        _date = State(initialValue: diary.date)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("수정")
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
                .foregroundStyle(CustomColor.SwiftUI.customBlack)
            }
            .padding()
            
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력해주세요", text: $title)
                }
                Section(header: Text("내용")) {
                    TextField("다짐을 입력해주세요", text: $content)
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
                    
                    if let uiImage = UIImage(data: image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .clipped()
                    }
                }
            }
            
            HStack {
                Button(action: {
                    showDeleteAlert = true // 삭제 버튼 누르면 알럿 표시
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
//                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.updateDiary(id: Int64(diary.id), title: title, content: content, image: image)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
//                        .font(.title)
                        .padding()
                        .background(CustomColor.SwiftUI.customBlack)
                        .clipShape(Circle())
                }
                .disabled(title.isEmpty || content.isEmpty)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images, photoLibrary: .shared())
        .onTapGesture {
            hideKeyboard()
        }
//        .onDisappear {
//            viewModel.fetchDiaries() // 삭제 후 목록이 즉시 업데이트되도록 호출
//        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        image = data
                    }
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("삭제 확인"),
                message: Text("이 다짐을 정말 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    viewModel.deleteDiary(id: Int64(diary.id))
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

//struct ImagePicker: UIViewControllerRepresentable {
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        var parent: ImagePicker
//
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let uiImage = info[.originalImage] as? UIImage, let imageData = uiImage.pngData() {
//                parent.selectedImageData = imageData
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//
//    @Binding var selectedImageData: Data?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .photoLibrary
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//}




//#Preview {
//    DiaryDetailView(viewModel: DiaryViewModel(), diary: Diary(id: 1, title: "오늘의 일기", content: "재미없는 하루였다", image: <#Data#>, date: Date()))
//}
