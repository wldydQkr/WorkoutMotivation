//
//  OnboardingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init(onboardingContents: [OnboardingContent] = [
        .init(
            imageFileName: "onboardingLottie",
            content:
                """
                반가워요!
                워크아웃모티베이션은
                운동에 대한
                동기부여를 줍니다.
                우리 모두 열심히
                운동하고 득근해요!
                """),
        .init(
            imageFileName: "list",
            content: """
                     나만의 다짐을
                     기록하고
                     기억해보세요!
                     """
        ),
        .init(
            imageFileName: "wish-list",
            content: """
                     좋아하는 명언을 골라
                     언제 어디서든 쉽게 
                     볼 수 있어요!
                     """
            ),
        .init(
            imageFileName: "notifications",
            content: """
                     좋아하는 명언을 골라
                     이제 원하는 시간에 
                     동기부여를 받아 보세요!
                     """
        )
    ]) {
        self.onboardingContents = onboardingContents
    }
}
