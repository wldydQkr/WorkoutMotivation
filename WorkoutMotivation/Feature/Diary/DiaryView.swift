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
    @State private var selectedDiary: Diary? = nil
    @State private var isDetailViewPresented = false
    
    init() {
        _viewModel = StateObject(wrappedValue: DiaryViewModel(context: PersistenceController.shared.viewContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CustomHeaderView(title: "나의 다짐") {
                        EmptyView() // 헤더 설정
                    }
                    
                    ScrollView {
                        if viewModel.diaries.isEmpty {
                            EmptyView() // 다이어리가 없을 때
                        } else {
                            ForEach(viewModel.diaries.sorted(by: { $0.date > $1.date })) { diary in
                                DiaryCardView(
                                    diary: diary,
                                    isEditing: $isEditing,
                                    selectedDiaries: $selectedDiaries,
                                    onDelete: {
                                        viewModel.deleteDiary(id: Int64(diary.id))
                                        viewModel.fetchDiaries() // 삭제 후 리스트 갱신
                                    }
                                )
                                .contentShape(Rectangle()) // 전체 영역이 탭 가능하도록 설정
                                .onTapGesture {
                                    viewModel.navigateToDetailView(for: diary)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
                .background(CustomColor.SwiftUI.customBackgrond)
                .navigationBarHidden(true)
                .sheet(isPresented: $isDetailViewPresented, onDismiss: {
                    // DetailView가 닫힐 때 데이터를 갱신
                    viewModel.fetchDiaries()
                }) {
                    if let selectedDiary = selectedDiary {
                        DiaryDetailView(viewModel: viewModel, diary: selectedDiary)
                    }
                }
                
                AddDiaryButton(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchDiaries() // 뷰가 나타날 때 다이어리 로드
            }
        }
    }
}

#Preview {
    DiaryView()
}
