//
//  MotivationDetailView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct MotivationDetailView: View {
    let title: String
    let name: String
    let motivation: Motivation
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MotivationViewModel
    @State private var shareContent: String = ""
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
                    .padding()
            } else {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(CustomColor.SwiftUI.customBlack)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text(name)
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundStyle(CustomColor.SwiftUI.customBlack2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    shareButton
                    likeButton
                        .padding()
                }
                .padding()
                pasteButton
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColor.SwiftUI.customBackgrond)
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [shareContent], isPresented: $isShareSheetPresented)
        }
    }
    
    private var pasteButton: some View {
        Button(action: {
            let combinedText = "\(title) - \(name)"
            UIPasteboard.general.string = combinedText
        }) {
            HStack {
                Image(systemName: "doc.on.clipboard")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
                Text("복사하기")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 30).stroke(CustomColor.SwiftUI.customGreen3, lineWidth: 2))
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(CustomColor.SwiftUI.customBlack)
            Text("Back")
                .foregroundColor(CustomColor.SwiftUI.customBlack)
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            // shareContent 설정
            shareContent = viewModel.getMotivationDetails(motivation)
            // 상태 업데이트 후 시트 표시
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isShareSheetPresented = true
            }
            print("shareContent: \(shareContent)")
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
                Text("공유하기")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
            }
            .onChange(of: shareContent) { newValue in
                if !newValue.isEmpty { 
                    isShareSheetPresented = true
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 30).stroke(CustomColor.SwiftUI.customGreen3, lineWidth: 2))
        }
    }
    
    private var likeButton: some View {
        Button(action: {
            viewModel.toggleLike(for: motivation)
        }) {
            HStack {
                Image(systemName: viewModel.isLiked(motivation) ? "heart.fill" : "heart")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
                Text("좋아해요")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 30).stroke(CustomColor.SwiftUI.customGreen3, lineWidth: 2))
        }
    }
}

#Preview {
    MotivationDetailView(title: "Sample", name: "Sample", motivation: Motivation(id: 1, title: "s", name: "s"), viewModel: MotivationViewModel())
}

