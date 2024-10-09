//
//  DiaryView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/14/24.
//
import SwiftUI

struct DiaryView: View {
    @StateObject private var viewModel: DiaryViewModel
    @State private var isEditing = false
    @State private var selectedDiaries = Set<Int>()
    
    init() {
        _viewModel = StateObject(wrappedValue: DiaryViewModel(context: PersistenceController.shared.viewContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CustomHeaderView(title: "나의 다짐") {
                        EmptyView()
                    }
                    
                    ScrollView {
                        if viewModel.diaries.isEmpty {
                            EmptyView()
                        } else {
                            ForEach(viewModel.diaries) { diary in
                                DiaryCardView(
                                    diary: diary,
                                    isEditing: $isEditing,
                                    selectedDiaries: $selectedDiaries,
                                    onDelete: {
                                        viewModel.deleteDiary(id: Int64(diary.id))
                                    }
                                )
                                .contentShape(Rectangle()) // 전체 영역이 탭 가능하도록 설정
                                .onTapGesture {
                                    navigateToDetailView(for: diary)
                                }
                                .listRowSeparator(.hidden) // 구분선 숨기기
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                }
                .background(CustomColor.SwiftUI.customBackgrond) // 전체 배경 색상 설정
                .navigationBarHidden(true)
                
                AddDiaryButton(viewModel: viewModel)
            }
        }
    }
    
    //TODO: ViewModel로 분리할 예정
    private func navigateToDetailView(for diary: Diary) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else { return }
        
        let vc = DiaryDetailView(viewModel: DiaryViewModel(), diary: diary)
        let hostingController = UIHostingController(rootView: vc)
        rootViewController.present(hostingController, animated: true, completion: nil)
    }
    
    //TODO: ViewModel로 분리할 예정
    private func deleteItems(at offsets: IndexSet) {
        offsets.map { viewModel.diaries[$0] }.forEach { diary in
            viewModel.deleteDiary(id: Int64(diary.id))
        }
    }
}

#Preview {
    DiaryView()
}
